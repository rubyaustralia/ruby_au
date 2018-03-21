require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  describe '.confirm_email' do
    let(:user) { FactoryGirl.build(:user) }
    let(:mail) { UserMailer.confirm_email(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq 'Confirm your email'
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ['no-reply@ruby.org.au']
    end

    it 'renders the body' do
      expect(mail.body).to have_text email_confirmation_url(token: user.token)
    end
  end
end
