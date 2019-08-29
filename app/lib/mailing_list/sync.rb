# frozen_string_literal: true

class MailingList::Sync
  def self.call
    MailingList.all.each do |list|
      new(list).call
    end
  end

  def initialize(list)
    @list = list
  end

  def call
    mark_users_as_unsubscribed

    each_subscriber do |subscriber|
      user = User.find_by email: subscriber['EmailAddress']
      next if user.nil?

      user.mailing_lists_will_change!
      user.mailing_lists[list.name] = true
      user.save
    end
  end

  private

  attr_reader :list

  def cm_auth
    {api_key: ENV['CAMPAIGN_MONITOR_API_KEY']}
  end

  def cm_list
    @cm_list ||= CreateSend::List.new cm_auth, list.api_id
  end

  def each_subscriber(&block)
    page = 1

    loop do
      results = cm_list.active('', page)
      results['Results'].each { |result| block.call result }

      break if results['PageNumber'] >= results['NumberOfPages']
      page += 1
    end
  end

  def mark_users_as_unsubscribed
    User.connection.execute <<~SQL
    UPDATE USERS
    SET mailing_lists = jsonb_set(mailing_lists::jsonb, '{#{list.name}}', 'false')::json
    SQL
  end
end
