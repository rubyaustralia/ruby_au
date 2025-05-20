require 'rails_helper'

RSpec.describe Campaigns::Send do
  let(:send_campaigns) { described_class.new(campaign) }
  let(:campaign) { instance_double(Campaign, delivered_at: nil, rsvp_event: nil) }
  let(:membership) { instance_double(Membership) }
  let(:memberships) { [membership] }
  let(:campaign_delivery) { instance_double(CampaignDelivery, delivered_at: nil) }

  before do
    mail_double = instance_double(ActionMailer::MessageDelivery, deliver_now: true)

    allow(Membership).to receive(:current).and_return(memberships)
    allow(send_campaigns).to receive(:delivery_for).with(membership).and_return(campaign_delivery)
    allow(campaign_delivery).to receive(:delivered_at=)
    allow(campaign_delivery).to receive(:save!)
    allow(campaign).to receive(:update)
    allow(CampaignsMailer).to receive(:campaign_email)
      .with(campaign, membership, nil)
      .and_return(mail_double)
  end

  context "when campaign is not delivered with existing memberships" do
    it "sends email and creates campaign delivery" do
      send_campaigns.call

      expect(CampaignsMailer).to have_received(:campaign_email)
        .with(campaign, membership, nil)
    end

    it "updates the campaign delivery" do
      send_campaigns.call

      expect(campaign_delivery).to have_received(:delivered_at=).with(anything)
    end
  end

  context "when campaign is not delivered without memberships" do
    before do
      allow(Membership).to receive(:current).and_return([])
    end

    it "does not send email" do
      send_campaigns.call

      expect(CampaignsMailer).not_to have_received(:campaign_email)
    end
  end
end
