require "rails_helper"

RSpec.describe 'Email Confirmation' do
  scenario 'valid credentials' do
    user = FactoryBot.create(:user)
    user.regenerate_token

    visit email_confirmation_path(token: user.token)

    expect(page).to have_content 'You email address is confirmed'
    expect(user.reload.email_confirmed).to eq true
  end

  scenario 'Invalid credentials' do
    visit email_confirmation_path(token: 'some_random_token')

    expect(page).to have_content 'Could not confirm your email address. Invalid token.'
  end
end
