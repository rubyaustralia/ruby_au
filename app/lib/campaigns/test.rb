# frozen_string_literal: true

class Campaigns::Test < Campaigns::Send
  def call
    memberships.each do |membership|
      CampaignsMailer.campaign_email(campaign, membership, ics).deliver_now
    end
  end

  private

  def memberships
    Membership.where(user: User.committee)
  end
end
