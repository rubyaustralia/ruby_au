# frozen_string_literal: true

class MailingList::Unsubscribe
  def self.call(user, list)
    new(user, list).call
  end

  def initialize(user, list)
    @user = user
    @list = list
  end

  def call
    CreateSend::Subscriber.new(
      cm_auth,
      list.api_id,
      user.email
    ).unsubscribe
  end

  private

  attr_reader :user, :list

  def cm_auth
    {api_key: ENV['CAMPAIGN_MONITOR_API_KEY']}
  end
end
