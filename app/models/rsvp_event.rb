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
  validates :title,
            presence: true

  validates :happens_at,
            presence: true,
            comparison: {
              greater_than: ->(_record) { Time.current },
              message: "can't be in the past"
            }

  scope :upcoming, -> { where('happens_at > ?', Time.current) }

  def upcoming?
    Time.current < happens_at
  end
end
