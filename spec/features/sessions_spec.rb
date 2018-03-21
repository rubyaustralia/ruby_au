require "rails_helper"

RSpec.describe 'Session' do
  scenario 'Sign in and out' do
    user = FactoryGirl.create(:user, email: 'littlebunnyfoofoo@gmail.com')

    visit sign_in_path
    fill_in "session_email", with: user.email
    fill_in "session_password", with: user.password
    click_button 'Sign in'

    expect(page).to have_content 'welcome to Ruby Australia'
    expect(page).to have_content user.preferred_name

    click_button 'Sign out'

    expect(page).to have_content 'Logged out!'
    expect(page).to_not have_content user.preferred_name
  end
end
