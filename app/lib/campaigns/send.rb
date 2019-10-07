# frozen_string_literal: true

class Campaigns::Send
  def self.call(campaign)
    new(campaign).call
  end

  def initialize(campaign)
    @campaign = campaign
  end

  def call
    return if campaign.delivered_at.present?

    campaign.update delivered_at: Time.current

    Membership.current.each do |membership|
      CampaignsMailer.campaign_email(campaign, membership).deliver_now
    end
  end

  private

  attr_reader :campaign
end
