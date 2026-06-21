# == Schema Information
#
# Table name: events
#
#  id               :bigint           not null, primary key
#  date             :date             not null
#  description      :text             not null
#  end_time         :datetime
#  event_type       :string           not null
#  name             :string           not null
#  region           :string           not null
#  registration_url :string
#  slug             :string           not null
#  start_time       :datetime         not null
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

  has_many   :talks, dependent: :destroy, inverse_of: :event
  belongs_to :venue

  validates :date, presence: true
  validates :description, presence: true
  validates :event_type, presence: true
  validates :name, presence: true
  validates :region, presence: true
  validates :slug, presence: true
  validates :start_time, presence: true

  def self.all_by_date
    all.order(date: :desc)
  end

  def to_param
    slug
  end

  def self.upcoming(amount = nil)
    all.select(&:today_or_in_the_future?).slice(0..amount&.-(1))
  end

  def self.past(amount = nil)
    all.reject(&:today_or_in_the_future?).reverse.slice(0..amount&.-(1))
  end

  def self.last(amount = 1)
    all.last(amount).reverse
  end

  def today_or_in_the_future?
    date.today? || date.future?
  end

  def date_region_event_type
    formatted_date = date.strftime("%Y-%m-%d")
    "#{formatted_date}-ruby-#{region}-#{event_type}"
  end

  def keywords
    "Events, Ruby, Rails, #{region.capitalize}"
  end

  def should_generate_new_friendly_id?
    date_changed? || region_changed? || event_type_changed? || super
  end
end
