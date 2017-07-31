require "rails_helper"

RSpec.describe "User edits profile details" do
  scenario "by filling in the form" do
    new_email = 'bigbunnyfoofoo@gmail.com'

    user = FactoryGirl.create(:user, email: 'littlebunnyfoofoo@gmail.com')
    login_as user
    visit profile_path

    click_on 'Edit'

    fill_in "user_email", with: new_email
    fill_in "user_preferred_name", with: "Big Bunny"
    find(:css, "#user_visible").set(true)
    click_button 'Update your details'

    user.reload
    expect(page).to have_content 'Your details have been updated.'
    expect(user.preferred_name).to eq "Big Bunny"
    expect(user.email).to eq new_email
    expect(user.visible).to be_truthy
  end
end
