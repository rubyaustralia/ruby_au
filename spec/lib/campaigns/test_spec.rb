require 'rails_helper'

RSpec.describe Campaigns::Test do
  subject { described_class }

  let(:committee_users) { create_list(:user, 3, :committee) }
  let(:non_committee_user) { create(:user) }
  let(:committee_memberships) { Membership.where(user: committee_users) }
  let(:non_committee_membership) { Membership.where(user: non_committee_user) }
  let(:campaign) { create(:campaign) }

  before do
    committee_memberships
    non_committee_membership
    allow(CampaignsMailer).to receive_message_chain(:campaign_email, :deliver_now)
  end
  describe '.call' do
    it 'delivers campaign delivery for committee users' do
      expect do
        subject.call(campaign)
      end.to change { CampaignDelivery.where(membership: committee_memberships).count }.by(3)
    end

    it 'does not deliver campaign delivery for non-committee users' do
      expect do
        subject.call(campaign)
      end.to change { CampaignDelivery.where(membership: non_committee_membership).count }.by(0)
    end
  end
end
