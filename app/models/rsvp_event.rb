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
  # happens_at is stored as a bare UTC instant — there is no time_zone column.
  # The admin form submits the wall-clock time together with the zone it was
  # entered in; we resolve the instant here so callers never have to juggle
  # Time.zone themselves.
  attr_accessor :time_zone

  before_validation :resolve_happens_at_time_zone

  validates :title,
            presence: true

  validate :time_zone_must_be_valid

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

  private

  # Time-zone-aware datetime attributes are cast lazily, using whatever Time.zone
  # is in effect *when the value is first read* — long after any Time.use_zone
  # block in a controller has exited. So a datetime_select is always interpreted
  # in the app's default zone, ignoring the zone the admin actually picked.
  #
  # We correct that here: read the wall-clock the admin entered (recovered in the
  # app's default zone, the same zone the lazy cast used) and re-interpret those
  # same digits in the selected zone. `time_zone` is consumed once resolved so
  # repeated validation can't shift the instant again.
  def resolve_happens_at_time_zone
    zone = ActiveSupport::TimeZone[time_zone.to_s]
    return if zone.nil? || happens_at.nil?

    wall = happens_at
    self.happens_at = zone.local(wall.year, wall.month, wall.day, wall.hour, wall.min, wall.sec)
    self.time_zone = nil
  end

  def time_zone_must_be_valid
    return if time_zone.blank?

    errors.add(:time_zone, "is not a valid time zone") if ActiveSupport::TimeZone[time_zone].nil?
  end
end
