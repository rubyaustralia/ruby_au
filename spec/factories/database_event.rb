# == Schema Information
#
# Table name: events
#
#  id                  :bigint           not null, primary key
#  date                :datetime         not null
#  description         :text             not null
#  end_time            :datetime
#  event_type          :string           not null
#  name                :string           not null
#  region              :string           not null
#  registration_url    :string
#  slug                :string           not null
#  start_time          :datetime         not null
#  venue_id            :bigint
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_events_on_venue_id             (venue_id)
#
FactoryBot.define do
  factory :database_event do
    date { 1.month.from_now }
    sequence :description do |n|
      "description_#{n}"
    end
    sequence :name do |n|
      "name_#{n}"
    end
    sequence :slug do |n|
      "slug-#{n}"
    end
    start_time { '6:30pm' }
    venue

    trait :meetup do
      event_type { :meetup }
    end

    trait :conference do
      event_type { :conference }
    end

    trait :melbourne do
      region { :melbourne }
    end

    trait :sydney do
      region { :sydney }
    end
  end
end

def database_event_with_talks(talks_count: 2, event_type: :meetup, region: :melbourne)
  FactoryBot.create(:database_event, event_type, region) do |database_event|
    FactoryBot.create_list(:talk, talks_count, event: database_event)
  end
end
