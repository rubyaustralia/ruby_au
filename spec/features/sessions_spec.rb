require "rails_helper"

RSpec.describe 'Session', type: :feature do
  scenario 'Sign in and out' do
    user = FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com')

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'

    click_link 'Log out'

    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unconfirmed account' do
    user = FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com', confirmed_at: nil)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button 'Log in'

    expect(page).to have_content(
      'You have to confirm your email address before continuing.'
    )
  end

  scenario 'Invalid credentials' do
    visit new_user_session_path
    fill_in "Email", with: 'invalid@email.com'
    fill_in "Password", with: 'randopassword'
    click_button 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

  scenario "Deactivated account" do
    user = FactoryBot.create(:user, email: 'littlebunnyfoofoo@gmail.com', deactivated_at: 1.minute.ago)

    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button 'Log in'

    expect(page).to have_content("Your membership has been deactivated.")
  end

  scenario 'Login with either of two emails' do
    user = FactoryBot.create(:user, email: 'test1@example.com')
    FactoryBot.create(:email, :confirmed, user: user, email: 'test2@example.com')

    visit new_user_session_path
    fill_in "Email", with: 'test1@example.com'
    fill_in "Password", with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
    click_link 'Log out'

    visit new_user_session_path
    fill_in "Email", with: 'test2@example.com'
    fill_in "Password", with: user.password
    click_button 'Log in'

    expect(page).to have_content 'Signed in successfully.'
  end
end
