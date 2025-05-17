require 'rails_helper'

RSpec.describe Campaigns::Send do
  subject(:send_service) do
    described_class.new(campaign)
  end

  let(:campaign) { Campaign.new(subject: "Test Subject", preheader: "Test Preheader") }
  let(:user) { instance_double(User, email: "test@example.com") }
  let(:membership) { instance_double(Membership, user: user, email: user.email) }
  let(:campaign_delivery) { instance_spy(CampaignDelivery, delivered_at: nil) }
  let(:message_delivery) { instance_double(ActionMailer::MessageDelivery, deliver_now: true) }

  def setup_common_stubs
    allow(CampaignsMailer).to receive(:campaign_email)
      .with(campaign, membership, anything)
      .and_return(message_delivery)
  end

  describe '#call when campaign is already delivered' do
    before do
      campaign.delivered_at = Time.current
      setup_common_stubs

      allow(Membership).to receive(:where).and_return([])
    end

    it 'does not send email and returns empty results' do
      result = send_service.call

      expect(CampaignsMailer).not_to have_received(:campaign_email)
      expect(result || []).to be_empty
    end
  end

  describe '#call when campaign is not delivered with existing memberships' do
    before do
      campaign.delivered_at = nil
      setup_common_stubs

      allow(Membership).to receive(:where).and_return([membership])

      allow(CampaignDelivery).to receive(:find_or_initialize_by)
        .with(campaign: campaign, membership: membership)
        .and_return(campaign_delivery)
    end

    it 'sends email and creates campaign delivery' do
      send_service.call

      expect(CampaignsMailer).to have_received(:campaign_email)
        .with(campaign, membership, anything)
    end

    it 'updates the campaign delivery' do
      send_service.call

      expect(campaign_delivery).to have_received(:delivered_at=).with(anything)
      expect(campaign_delivery).to have_received(:save!)
    end

    it 'returns a successful result' do
      result = send_service.call
      expect(result).to be_truthy
    end
  end

  describe '#call when campaign is not delivered without memberships' do
    before do
      campaign.delivered_at = nil
      setup_common_stubs
      allow(Membership).to receive(:where).and_return([])
    end

    it 'does not send email' do
      send_service.call
      expect(CampaignsMailer).not_to have_received(:campaign_email)
    end
  end
end
