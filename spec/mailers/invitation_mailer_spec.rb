require "rails_helper"

RSpec.describe InvitationMailer, type: :mailer do
  describe '#invite' do
    subject(:mail) { described_class.with(email: 'john.doe@email.com', name: 'John Doe').invite.deliver_now }

    it 'renders the subject' do
      expect(mail.subject).to eq("Ruby Australia Membership")
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

    it 'includes confirmation link if token is present' do
      mail = described_class.with(email: 'john.doe@email.com', name: 'John Doe', token: 'some-token').invite.deliver_now

      expect(mail.body.encoded).to match(invitation_url('some-token'))
    end

    it 'includes sources if provided' do
      mail = described_class.with(email: 'john.doe@email.com', name: 'John Doe', sources: ['Some Conference']).invite.deliver_now

      expect(mail.body.encoded).to match("Some Conference")
    end
  end
end
