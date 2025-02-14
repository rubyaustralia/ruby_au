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
    return true if Rails.env.development? && ENV['CAMPAIGN_MONITOR_API_KEY'].blank?

    CreateSend::Subscriber.get(
      cm_auth,
      list.api_id,
      user.email
    )["State"] == "Active"
  rescue CreateSend::BadRequest => br
    Rails.logger.error "Campaign Monitor Bad Request: #{br}"
    Rails.logger.error "Error Code: #{br.data.Code}"
    Rails.logger.error "Error Message: #{br.data.Message}"
    false
  rescue CreateSend::Unauthorized => ua
    Rails.logger.error "Campaign Monitor Unauthorized: #{ua}"
    Rails.logger.error "Error Code: #{ua.data.Code}"
    Rails.logger.error "Error Message: #{ua.data.Message}"
    false
  rescue StandardError => e
    Rails.logger.error "Campaign Monitor Error: #{e}"
    false
  end
end
