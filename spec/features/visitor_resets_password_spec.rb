require "rails_helper"

RSpec.feature "Visitor resets password" do
  before { ActionMailer::Base.deliveries.clear }

  around do |example|
    original_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = :inline
    example.run
    ActiveJob::Base.queue_adapter = original_adapter
  end

  scenario "by navigating to the page" do
    visit sign_in_path

    click_link 'Forgot password?'

    expect(current_path).to eq new_password_path
  end

  scenario "with valid email" do
    user = FactoryBot.create(:user)
    reset_password_for user.email
    user.reload

    expect(page).to have_content 'You will receive an email within the next few minutes'
    expect(user.token).not_to be_blank
    expect_mailer_to_have_delivery(
      user.email,
      "password",
      user.token
    )
  end

  scenario "with non-user account" do
    reset_password_for "unknown.email@example.com"

    expect(page).to have_content 'You will receive an email within the next few minutes'
    expect(ActionMailer::Base.deliveries).to be_empty
  end

  scenario 'editing the password' do
    user = FactoryBot.create(:user)
    user.regenerate_token

    visit edit_profile_password_path(token: user.token)
    fill_in 'Password', with: 'password'
    click_button 'Update password'

    expect(page).to have_content 'Your password was updated'
  end

  scenario 'invalid edit password link' do
    visit edit_profile_password_path(token: 'some_random_token')

    expect(page).to have_content 'Link has expired'
  end

  def expect_mailer_to_have_delivery(recipient, subject, body)
    expect(ActionMailer::Base.deliveries).not_to be_empty

    message = ActionMailer::Base.deliveries.any? do |email|
      email.to == [recipient] &&
        email.subject =~ /#{subject}/i &&
        email.body.to_s =~ /#{body}/
    end

    expect(message).to be
  end

  def reset_password_for(email)
    visit new_password_path
    fill_in "change_password_email", with: email
    click_button 'Reset password'
  end
end
