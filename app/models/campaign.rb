class Campaign < ApplicationRecord
  belongs_to :rsvp_event, optional: true

  def delivered?
    delivered_at.present?
  end
end
