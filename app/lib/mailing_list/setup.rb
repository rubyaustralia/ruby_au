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
    CreateSend::Subscriber.get(
      cm_auth,
      list.api_id,
      user.email
    )["State"] == "Active"
  rescue CreateSend::BadRequest
    false
  end
end
