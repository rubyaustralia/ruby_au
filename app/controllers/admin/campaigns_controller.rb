# frozen_string_literal: true

class Admin::CampaignsController < Admin::ApplicationController
  expose(:campaigns) { Campaign.order(created_at: :desc).page params[:page] }
  expose(:campaign) do
    params[:id] ? Campaign.find(params[:id]) : Campaign.new(campaign_params)
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

  private

  def campaign_params
    params.fetch(:campaign, {}).permit(:subject, :preheader, :content, :rsvp_event_id)
  end
end
