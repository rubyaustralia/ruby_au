# frozen_string_literal: true

class MailingList::CreateWebhooks
  def self.call
    MailingList.each do |list|
      new(list).call
    end
  end

  def initialize(list)
    @list = list
  end

  def call
    routes.default_url_options = Rails.application.config.action_mailer.default_url_options

    cm_list.create_webhook(
      %w[Subscribe Deactivate], # events
      routes.url_helpers.hook_mailing_list_url(list.api_id), # url
      "json" # format
    )
  end

  private

  attr_reader :list

  def cm_auth
    { api_key: ENV['CAMPAIGN_MONITOR_API_KEY'] }
  end

  def cm_list
    @cm_list ||= CreateSend::List.new cm_auth, list.api_id
  end

  def routes
    Rails.application.routes
  end
end
