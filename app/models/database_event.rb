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

  has_many   :talks, dependent: :destroy, inverse_of: :event
  belongs_to :venue

  scope :all_by_date, -> { order(date: :desc) }
  scope :today_or_in_the_future, -> { order(date: :asc).where('date >= ?', Time.zone.today) }
  scope :before_today, -> { all_by_date.where('date < ?', Time.zone.today) }

  validates :date, presence: true
  validates :description, presence: true
  validates :event_type, presence: true
  validates :name, presence: true
  validates :region, presence: true
  validates :slug, presence: true
  validates :start_time, presence: true

  def to_param
    slug
  end

  def self.upcoming(amount = nil)
    today_or_in_the_future.limit(amount)
  end

  def self.past(amount = nil)
    before_today.limit(amount)
  end
end
