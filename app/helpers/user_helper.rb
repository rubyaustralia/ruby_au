# frozen_string_literal: true

module UserHelper
  def subscribed_mailing_lists(user)
    lists = user.mailing_lists.keys.select do |key|
      user.mailing_lists[key] == "true"
    end

    lists.empty? ? "None" : lists.join(", ")
  end

  def job_seekers_available?
    Rails.cache.fetch('job_seekers_available', expires_in: 5.minutes) do
      User.seeking_work.joins(:memberships).where(memberships: { left_at: nil }).exists?
    end
  end
end
