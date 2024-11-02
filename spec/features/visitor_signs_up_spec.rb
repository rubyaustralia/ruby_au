require "rails_helper"

RSpec.feature "Visitor signs up", type: :feature do
  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password"
    expect(page).to have_content 'A message with a confirmation link has been sent to your email address.'

    verify_user_presence("valid@example.com")
    verify_user_not_confirmed("valid@example.com")
  end

  scenario "tries with invalid email" do
    sign_up_with "invalid_email", "password"
    expect_user_not_to_be_registered
  end

  scenario "tries with blank password" do
    sign_up_with "valid@example.com", ""
    expect_user_not_to_be_registered
  end

  scenario "as a user" do
    simulate_registration
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

  def verify_user_presence(email)
    user = User.find_by(email: email)
    expect(user).to be_present
  end

  def verify_user_not_confirmed(email)
    user = User.find_by(email: email)
    expect(user).not_to be_confirmed
    expect(user.memberships.count).to be_zero
  end

  def simulate_registration
    visit new_user_registration_path
    fill_in "Email", with: "valid@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
    fill_in "Full Name", with: 'Jane Doe'
    fill_in "Postal Address", with: '1 High Street'
    check "Rails Camp"
    fill_in "Ruby?", with: "Random bot generated string"
    click_button 'Register'
  end

  def expect_user_not_to_be_registered
    expect(page).to have_content 'Register for Membership'
  end
end
