class RsvpEvent < ApplicationRecord
  validates :title,      presence: true
  validates :happens_at, presence: true
end
