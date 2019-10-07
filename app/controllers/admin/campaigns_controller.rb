# frozen_string_literal: true

class Admin::CampaignsController < Admin::ApplicationController
  expose(:campaigns) { Campaign.order(created_at: :desc).page params[:page] }
  expose(:campaign) do
    params[:id] ? Campaign.find(params[:id]) : Campaign.new(campaign_params)
  end
  expose(:events) { RsvpEvent.order(happens_at: :desc) }

  before_action :deny_if_sent, only: %i[update destroy]

  def show
    membership = current_user.memberships.current.first
    mail = CampaignsMailer.campaign_email campaign, membership

    # rubocop:disable Rails/OutputSafety
    render html: mail.body.to_s.html_safe, layout: nil
    # rubocop:enable Rails/OutputSafety
  end

  def create
    if campaign.save
      redirect_to admin_campaigns_path, notice: "Your campaign has been created."
    else
      render :new
    end
  end

  def update
    if campaign.update campaign_params
      redirect_to admin_campaigns_path, notice: "Your campaign has been updated."
    else
      render :edit
    end
  end

  def destroy
    campaign.destroy

    redirect_to admin_campaigns_path, notice: "Your campaign has been deleted."
  end

  private

  def campaign_params
    params.fetch(:campaign, {}).permit(:subject, :preheader, :content, :rsvp_event_id)
  end

  def deny_if_sent
    return unless campaign.delivered?

    redirect_to admin_campaigns_path, notice: "This campaign has already been sent."
  end
end
