# == Schema Information
#
# Table name: rsvp_events
#
#  id         :bigint           not null, primary key
#  happens_at :datetime         not null
#  link       :string
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class RsvpEvent < ApplicationRecord
  validates :title,      presence: true
  validates :happens_at, presence: true

  scope :upcoming, -> { where('happens_at > NOW()') }
end
