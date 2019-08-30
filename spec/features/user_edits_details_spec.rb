require "rails_helper"

RSpec.describe "User edits profile details", type: :feature do
  let(:user) { FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com') }

  before do
    log_in_as user
    visit my_details_path
  end

  scenario "by filling in the form" do
    new_email = 'bigbunnyfoofoo@gmail.com'

    click_on 'Edit'

    fill_in "Email", with: new_email
    fill_in "Full Name", with: "Big Bunny"
    find(:css, "#user_visible").set(true)
    click_button 'Update my details'

    user.reload
    expect(page).to have_content 'Your details have been updated.'
    expect(user.full_name).to eq "Big Bunny"
    expect(user.unconfirmed_email).to eq new_email
    expect(user.visible).to eq(true)
  end

  scenario "subscribing to a mailing list" do
    stub_request(
      :post, "https://api.createsend.com/api/v3.2/subscribers/girls-key.json"
    )

    click_on "Edit"

    check "RailsGirls"
    click_button "Update my details"

    user.reload
    expect(user.mailing_lists["RailsGirls"]).to eq("true")

    expect(a_request(
      :post, "https://api.createsend.com/api/v3.2/subscribers/girls-key.json"
    )).to have_been_made.once
  end

  scenario "unsubscribing from a mailing list" do
    user.update mailing_lists: {"RailsGirls" => "true"}
    stub_request(
      :post, "https://api.createsend.com/api/v3.2/subscribers/girls-key/unsubscribe.json"
    )

    click_on "Edit"

    uncheck "RailsGirls"
    click_button "Update my details"

    user.reload
    expect(user.mailing_lists["RailsGirls"]).to eq("false")

    expect(a_request(
      :post, "https://api.createsend.com/api/v3.2/subscribers/girls-key/unsubscribe.json"
    )).to have_been_made.once
  end

  scenario "updating password" do
    click_on 'Edit'

    fill_in "New password", with: 'newpassword'
    fill_in "Confirm new password", with: 'newpassword'
    fill_in "Current password", with: user.password
    click_button 'Change my password'

    user.reload
    expect(page).to have_content 'Your password has been updated. You will need to sign in again to continue.'
    expect(user.valid_password?('newpassword')).to eq(true)
  end
end
