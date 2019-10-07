class Campaign < ApplicationRecord
  belongs_to :rsvp_event, optional: true
end
