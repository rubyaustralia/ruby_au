# frozen_string_literal: true

class MailingList::Update
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
      user.email_before_last_save
    ).update(
      user.email,
      user.full_name,
      nil, # custom fields
      nil, # resubscribe
      nil  # consent_to_track
    )
  end

  private

  attr_reader :user, :list

  def cm_auth
    {api_key: ENV['CAMPAIGN_MONITOR_API_KEY']}
  end
end
