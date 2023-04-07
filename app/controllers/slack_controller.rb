class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  # Responds to POST requests from Slack Apps using the Events API https://api.slack.com/apis/connections/events-api
  def hook
    head :forbidden and return unless authorized?

    render json: { challenge: params[:challenge] } and return if params[:challenge]

    if Slack::EventHandler.call(event_data: params[:event])
      head :no_content
    else
      head :not_found
    end
  end

  private

  def authorized?
    params[:token] == ENV['SLACK_APP_TOKEN']
  end
end
