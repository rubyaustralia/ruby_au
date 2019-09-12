class RsvpEvent < ApplicationRecord
  validates :title,      presence: true
  validates :happens_at, presence: true

  scope :upcoming, -> { where('happens_at > NOW()') }
end
