require "rails_helper"

RSpec.describe 'Session' do
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
end
