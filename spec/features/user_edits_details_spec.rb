require "rails_helper"

RSpec.describe "User edits profile details" do
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

  def log_in_as(user)
    visit new_user_session_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to have_content("Signed in successfully")
    expect(page).to have_content("Log out")
  end
end
