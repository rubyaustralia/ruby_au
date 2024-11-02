# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Campaigns::Send do
  let(:user) { create(:user) }
  let(:campaign) { create(:campaign) }
  let(:membership) { user.memberships.first }
  let(:campaign_delivery) { create(:campaign_delivery, campaign: campaign, membership: membership) }

  before do
    membership
    allow(CampaignsMailer).to receive_message_chain(:campaign_email, :deliver_now)
  end

  describe '.call' do
    subject { described_class.call(campaign) }

    context 'when campaign has already been delivered' do
      before do
        campaign_delivery
        campaign.update!(delivered_at: Time.current)
      end

      it 'does not send any emails' do
        expect(CampaignsMailer).not_to receive(:campaign_email)
        subject
      end
    end

    context 'when campaign has not been delivered' do
      before { campaign.update(delivered_at: nil) }

      context 'and memberships exist' do
        it 'sends emails to all memberships' do
          expect(CampaignsMailer).to receive(:campaign_email).with(campaign, membership, anything).and_call_original
          subject
        end

        it 'generate the delivery' do
          expect { subject }.to change { CampaignDelivery.count }.by(1)
        end

        it 'updates the campaign delivery time' do
          subject
          expect(CampaignDelivery.first.delivered_at).to be_present
        end
      end

      context 'and no memberships exist' do
        before do
          membership.update!(left_at: Time.current)
        end

        it 'does not send any emails' do
          expect(CampaignsMailer).not_to receive(:campaign_email)
          subject
        end
      end
    end
  end
end
