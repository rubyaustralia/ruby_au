require "rails_helper"

RSpec.feature "Visitor signs up", type: :feature do
  scenario "by navigating to the page" do
    visit new_user_session_path

    click_link 'Join'

    expect(page).to have_current_path new_user_registration_path, ignore_query: true
  end

  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password"

    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'
    expect(page).not_to have_link('Sign out')

    user = Email.find_by(email: "valid@example.com").user
    expect(user).to be_present
    expect(user).not_to be_confirmed
    expect(user.memberships.count).to be_zero
  end

  scenario "tries with invalid email" do
    sign_up_with "invalid_email", "password"

    expect_user_not_to_be_registered
  end

  scenario "tries with blank password" do
    sign_up_with "valid@example.com", ""

    expect_user_not_to_be_registered
  end

  scenario "as a bot" do
    visit new_user_registration_path

    fill_in "Email", with: "valid@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    fill_in "Full Name", with: 'Jane Doe'
    fill_in "Postal Address", with: '1 High Street'

    check "Rails Camp"

    fill_in "Ruby?", with: "Random bot generated string"

    click_button 'Register'

    expect_user_not_to_be_registered
    expect(User.count).to be_zero
  end

  def sign_up_with(email, password)
    visit new_user_registration_path

    fill_in "Email", with: email
    fill_in "Password", with: password
    fill_in "Confirm Password", with: password
    fill_in "Full Name", with: 'Jane Doe'
    fill_in "Postal Address", with: '1 High Street'

    check "Rails Camp"

    fill_in "Ruby?", with: "Ruby"

    click_button 'Register'
  end

  def expect_user_not_to_be_registered
    expect(page).to have_content 'Register for Membership'
  end
end
