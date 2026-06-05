# frozen_string_literal: true

class Campaigns::Send
  def self.call(campaign)
    new(campaign).call
  end

  def initialize(campaign)
    @campaign = campaign
  end

  def call
    campaign.with_lock do
      return if campaign.delivered_at.present?

      memberships.each { |membership| send_to_membership(membership) }

      campaign.update! delivered_at: Time.current
    end
  end

  private

  def send_to_membership(membership)
    delivery = delivery_for membership
    return if delivery.delivered_at.present?

    CampaignsMailer.campaign_email(campaign, membership, ics).deliver_now

    delivery.delivered_at = Time.current
    delivery.save!
  end

  attr_reader :campaign

  delegate :rsvp_event, to: :campaign

  def delivery_for(membership)
    CampaignDelivery.find_or_initialize_by(
      campaign: campaign,
      membership: membership
    )
  end

  def memberships
    Membership.current.includes(:user)
  end

  def ics
    return nil if rsvp_event.nil?

    @ics ||= Campaigns::Event.call(rsvp_event)
  end
end
