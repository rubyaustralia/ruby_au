require 'rails_helper'

RSpec.describe Campaigns::Test do
  subject(:test_service) { described_class }

  let(:committee_users) { create_list(:user, 3, :committee) }
  let(:non_committee_user) { create(:user) }
  let(:committee_memberships) { Membership.where(user: committee_users) }
  let(:non_committee_membership) { Membership.where(user: non_committee_user) }
  let(:campaign) { create(:campaign) }

  before do
    committee_memberships
    non_committee_membership
    message_delivery = instance_double(ActionMailer::MessageDelivery, deliver_now: true)
    allow(CampaignsMailer).to receive(:campaign_email).and_return(message_delivery)
  end

  describe '.call' do
    it 'sends emails to committee users without creating delivery records' do
      expect do
        test_service.call(campaign)
      end.not_to(change(CampaignDelivery, :count))

      expect(CampaignsMailer).to have_received(:campaign_email).exactly(3).times
    end

    it 'does not send emails to non-committee users' do
      test_service.call(campaign)

      non_committee_membership.each do |membership|
        expect(CampaignsMailer).not_to have_received(:campaign_email).with(campaign, membership, anything)
      end
    end

    it 'does not mark the campaign as delivered' do
      expect do
        test_service.call(campaign)
      end.not_to(change { campaign.reload.delivered_at })
    end

    it 'allows multiple test sends without issues' do
      expect do
        test_service.call(campaign)
        test_service.call(campaign)
      end.not_to(change(CampaignDelivery, :count))

      expect(CampaignsMailer).to have_received(:campaign_email).exactly(6).times
    end
  end
end
