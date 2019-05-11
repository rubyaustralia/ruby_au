require "rails_helper"

RSpec.feature "Visitor signs up" do
  before { skip }

  scenario "by navigating to the page" do
    visit sign_in_path

    click_link 'Sign up'

    expect(current_path).to eq sign_up_path
  end

  scenario "with valid email and password" do
    sign_up_with "valid@example.com", "password"

    expect(page).to have_content 'Thanks for registering as a member!'
    expect(page).to have_button 'Sign out'
  end

  scenario "tries with invalid email" do
    sign_up_with "invalid_email", "password"

    expect_user_not_to_be_registered
  end

  scenario "tries with blank password" do
    sign_up_with "valid@example.com", ""

    expect_user_not_to_be_registered
  end

  def sign_up_with(email, password)
    visit sign_up_path
    fill_in "user_email", with: email
    fill_in "user_password", with: password
    fill_in "user_full_name", with: 'Jane Doe'
    fill_in "user_preferred_name", with: 'Jane'
    click_button 'Sign up'
  end

  def expect_user_not_to_be_registered
    expect(page).to have_content 'Sign up'
  end
end
