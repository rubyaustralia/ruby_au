# == Schema Information
#
# Table name: events
#
#  id               :bigint           not null, primary key
#  end_time         :datetime
#  event_type       :string           not null
#  name             :string           not null
#  region           :string           not null
#  registration_url :string
#  slug             :string           not null
#  start_datetime   :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  venue_id         :bigint
#
# Indexes
#
#  index_events_on_venue_id  (venue_id)
#
class DatabaseEvent < ApplicationRecord
  self.table_name = "events"

  extend FriendlyId
  friendly_id :date_region_event_type, use: :slugged

  has_rich_text :description

  has_many   :talks, dependent: :destroy, inverse_of: :event
  belongs_to :venue, optional: true

  scope :all_by_date, -> { order(start_datetime: :desc) }
  scope :today_or_in_the_future, -> { order(start_datetime: :asc).where(start_datetime: Time.zone.now.beginning_of_day..) }
  scope :before_today, -> { all_by_date.where(start_datetime: ...Time.zone.now.beginning_of_day) }

  validates :start_datetime, presence: true
  validates :event_type, presence: true
  validates :name, presence: true
  validates :region, presence: true
  validates :slug, presence: true

  def to_param
    slug
  end

  # Same API as the YAML-based Event, so presenters and views can treat both alike.
  # TODO Can be removed once DatabaseEvent becomes Event and the Presenter is updated.
  def date
    start_datetime&.to_date
  end

  def start_time
    start_datetime
  end

  def self.upcoming(amount = nil)
    today_or_in_the_future.limit(amount)
  end

  def self.past(amount = nil)
    before_today.limit(amount)
  end

  def date_region_event_type
    formatted_date = start_datetime.strftime("%Y-%m-%d")
    "#{formatted_date}-ruby-#{region}-#{event_type}"
  end

  def keywords
    "Events, Ruby, Rails, #{region.capitalize}"
  end

  def should_generate_new_friendly_id?
    start_datetime_changed? || region_changed? || event_type_changed? || super
  end
end
