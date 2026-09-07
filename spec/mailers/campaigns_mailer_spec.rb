require "rails_helper"

RSpec.describe CampaignsMailer, type: :mailer do
  describe '#campaign_email' do
    it "sends to the user's primary email" do
      user = create(:user, email: 'old@example.com')
      membership = user.memberships.current.first!
      user.emails.find_each { |email| email.update!(primary: false) }
      create(
        :email,
        user: user,
        email: 'primary@example.com',
        primary: true,
        skip_trigger_after_confirmation: true
      )
      campaign = create(:campaign, subject: 'Test campaign')

      mail = described_class.campaign_email(campaign, membership, nil).deliver_now

      expect(mail.to).to eq(['primary@example.com'])
    end

    it "falls back to the user's default email if no primary email exists" do
      user = create(:user, email: 'fallback@example.com').tap do |record|
        record[:email] = 'fallback@example.com'
        record.save!
        record.emails.destroy_all
      end
      membership = user.memberships.current.first || create(:membership, user: user)
      campaign = create(:campaign, subject: 'Test campaign')

      mail = described_class.campaign_email(campaign, membership, nil).deliver_now

      expect(mail.to).to eq(['fallback@example.com'])
    end
  end
end
