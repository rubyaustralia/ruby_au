require 'rails_helper'

RSpec.describe Campaigns::Send do
  subject(:send_service) { described_class.new(campaign) }

  let(:campaign) { Campaign.new(subject: "Test Subject", preheader: "Test Preheader") }
  let(:user) { double("User", email: "test@example.com") }
  let(:membership) { double("Membership", user: user, email: user.email) }

  describe '#call' do
    context 'when campaign is already delivered' do
      before do
        campaign.delivered_at = Time.current

        allow(send_service).to receive(:memberships).and_return([])
      end

      it 'does not send email and returns empty results' do
        allow(CampaignsMailer).to receive(:campaign_email)

        result = send_service.call

        expect(CampaignsMailer).not_to have_received(:campaign_email)
        expect(result || []).to be_empty
      end
    end

    context 'when campaign is not yet delivered' do
      before do
        campaign.delivered_at = nil
      end

      context 'with existing memberships' do
        let(:campaign_delivery) do
          double(
            "CampaignDelivery",
            delivered_at: nil,
            'delivered_at=' => nil,
            save!: true
          )
        end

        before do
          allow(send_service).to receive_messages(memberships: [membership], ics: nil)
          allow(send_service).to receive(:delivery_for)
            .with(membership)
            .and_return(campaign_delivery)

          allow(CampaignsMailer).to receive(:campaign_email)
            .with(campaign, membership, anything)
            .and_return(double("MessageDelivery", deliver_now: true))
        end

        it 'sends email and creates campaign delivery' do
          send_service.call

          expect(CampaignsMailer).to have_received(:campaign_email)
            .with(campaign, membership, anything)
        end

        it 'increments the campaign delivery count' do
          expect(campaign_delivery).to receive(:delivered_at=).with(anything)
          expect(campaign_delivery).to receive(:save!)

          send_service.call
        end

        it 'returns a successful result' do
          result = send_service.call

          expect(result).to be_truthy
        end
      end

      context 'without memberships' do
        before do
          allow(send_service).to receive(:memberships).and_return([])
          allow(CampaignsMailer).to receive(:campaign_email)
        end

        it 'does not send email' do
          send_service.call

          expect(CampaignsMailer).not_to have_received(:campaign_email)
        end
      end
    end
  end
end
