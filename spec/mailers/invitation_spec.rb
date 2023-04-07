require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe '#invite' do
    subject(:mail) { described_class.with(email: 'john.doe@email.com', name: 'John Doe').invite.deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq("You're invited to join Ruby Australia")
    end

    it 'uses supplied email' do
      expect(mail.to).to include('john.doe@email.com')
    end

    it 'contains name' do
      expect(mail.body.encoded).to match('Hi John Doe,')
    end

    it 'handles missing name' do
      mail_without_name = described_class.with(email: 'john.doe@email.com').invite.deliver_now

      expect(mail_without_name.body.encoded).to match('Hi,')
    end

    it 'includes sign up url' do
      expect(mail.body.encoded).to match(user_registration_url)
    end
  end
end
