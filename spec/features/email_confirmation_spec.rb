require "rails_helper"

RSpec.describe 'Email Confirmation' do
  scenario 'valid credentials' do
    user = FactoryBot.create(:user)
    user.regenerate_token

    visit email_confirmation_path(token: user.token)

    expect(page).to have_content 'Your email address is now confirmed.'
    expect(user.reload.email_confirmed).to eq true
  end

  scenario 'Invalid credentials' do
    visit email_confirmation_path(token: 'some_random_token')

    expect(page).to have_content 'We could not confirm your email address - the supplied token is invalid.'
  end
end
