# frozen_string_literal: true

class MailingList::Setup
  def self.call(user)
    MailingList.each do |list|
      new(user, list).call
    end
  end

  def initialize(user, list)
    @user = user
    @list = list
  end

  def call
    user.mailing_lists_will_change!
    user.mailing_lists[list.name] = subscribed? ? "true" : "false"
    user.save
  end

  private

  attr_reader :user, :list

  def cm_auth
    { api_key: ENV['CAMPAIGN_MONITOR_API_KEY'] }
  end

  def subscribed?
    return true if development_without_api_key?

    response = fetch_subscription_status
    handle_subscription_response(response)
  rescue CreateSend::BadRequest, CreateSend::Unauthorized, StandardError => e
    log_campaign_monitor_error(e)
    false
  end

  def development_without_api_key?
    Rails.env.development? && ENV['CAMPAIGN_MONITOR_API_KEY'].blank?
  end

  def fetch_subscription_status
    CreateSend::Subscriber.get(cm_auth, list.api_id, user.email)
  end

  def handle_subscription_response(response)
    response && response["State"] == "Active"
  end

  def log_campaign_monitor_error(error)
    Rails.logger.error "Campaign Monitor Error: #{error}"
    return unless error.respond_to?(:data)

    Rails.logger.error "Error Code: #{error.data.Code}" if error.data.respond_to?(:Code)
    Rails.logger.error "Error Message: #{error.data.Message}" if error.data.respond_to?(:Message)
  end
end
