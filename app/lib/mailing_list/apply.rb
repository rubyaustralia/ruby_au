# frozen_string_literal: true

class MailingList::Apply
  def self.call(user)
    new(user).call
  end

  def initialize(user)
    @user = user
  end

  def call
    return unless user.mailing_lists_previously_changed?

    new_subscribed_lists.each do |list|
      MailingList::Subscribe.call user, list
    end

    new_unsubscribed_lists.each do |list|
      MailingList::Unsubscribe.call user, list
    end
  end

  private

  attr_reader :user

  def changes
    user.previous_changes["mailing_lists"]
  end

  def new_subscribed_lists
    selected_lists(changes.last) - selected_lists(changes.first)
  end

  def new_unsubscribed_lists
    selected_lists(changes.first) - selected_lists(changes.last)
  end

  def selected_lists(hash)
    selected = hash.keys.select { |key| hash[key] == "true" }

    MailingList.all.select { |list| selected.include?(list.name) }
  end
end
