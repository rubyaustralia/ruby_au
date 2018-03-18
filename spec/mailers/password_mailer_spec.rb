require 'rails_helper'

RSpec.describe PasswordMailer, type: :mailer do
  describe '.change_password' do
    let(:user) { FactoryGirl.build(:user) }
    let(:mail) { PasswordMailer.change_password(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq 'Change your password'
      expect(mail.to).to eq [user.email]
      expect(mail.from).to eq ['no-reply@ruby.org.au']
    end

    it 'renders the body' do
      expect(mail.body).to have_text edit_profile_password_url(token: user.token)
    end
  end
end
