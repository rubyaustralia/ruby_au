# frozen_string_literal: true

module UserHelper
  def subscribed_mailing_lists(user)
    lists = user.mailing_lists.keys.select do |key|
      user.mailing_lists[key] == "true"
    end

    lists.empty? ? "None" : lists.join(", ")
  end
end
