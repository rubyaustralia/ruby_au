require "rails_helper"

RSpec.describe "User edits profile details", type: :feature do
  let(:user) { FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com') }

  before do
    log_in_as user
    visit my_details_path
  end

  scenario "updating full name" do
    click_on 'Edit'

    fill_in "Full Name", with: "Big Bunny"
    find(:css, "#user_visible").set(true)
    click_button 'Update my details'

    expect(page).to have_content 'Your details have been updated.'
    expect(page).to have_content 'Big Bunny'
  end

  scenario "adding a new email" do
    user.update! mailing_lists: { "RubyConf AU" => "true" }
    new_email = 'bigbunnyfoofoo@gmail.com'
    stub_request(
      :post, %r{https://api.createsend.com/api/v3.3/subscribers/conf-key.json}
    )
    stub_request(
      :put, %r{https://api.createsend.com/api/v3.3/subscribers/conf-key.json}
    )

    click_on 'Add Email'

    fill_in "Email", with: new_email
    click_button 'Add New Email'

    expect(page).to have_content "Your email #{new_email} has been added."

    email = emails_sent_to(new_email).detect do |mail|
      mail.subject == "Confirmation instructions"
    end
    expect(email).to be_present

    email.click_link "Confirm my membership"

    expect(
      a_request(
        :post, %r{https://api.createsend.com/api/v3.3/subscribers/conf-key.json}
      )
    ).to have_been_made
  end

  scenario "subscribing to a mailing list" do
    user.update! mailing_lists: { "RubyConf AU" => "true" }
    stub_request(
      :post, "https://api.createsend.com/api/v3.3/subscribers/girls-key.json"
    )

    click_on "Edit"

    check "RailsGirls"
    click_button "Update my details"

    user.reload
    expect(user.mailing_lists["RailsGirls"]).to eq("true")

    expect(
      a_request(
        :post, "https://api.createsend.com/api/v3.3/subscribers/girls-key.json"
      )
    ).to have_been_made.once
  end

  scenario "unsubscribing from a mailing list" do
    user.update! mailing_lists: { "RailsGirls" => "true" }
    stub_request(
      :post, "https://api.createsend.com/api/v3.3/subscribers/girls-key/unsubscribe.json"
    )

    click_on "Edit"

    uncheck "RailsGirls"
    click_button "Update my details"

    user.reload
    expect(user.mailing_lists["RailsGirls"]).to eq("false")

    expect(
      a_request(
        :post, "https://api.createsend.com/api/v3.3/subscribers/girls-key/unsubscribe.json"
      )
    ).to have_been_made.once
  end

  scenario "updating password" do
    click_on 'Edit'

    fill_in "New password", with: 'newpassword'
    fill_in "Confirm new password", with: 'newpassword'
    fill_in "Current password", with: user.password
    click_button 'Change my password'

    user.reload
    expect(page).to have_content 'Your password has been updated. You will need to sign in again to continue.'
    expect(user.valid_password?('newpassword')).to be(true)
  end
end
