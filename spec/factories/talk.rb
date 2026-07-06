# == Schema Information
#
# Table name: talks
#
#  id                  :bigint           not null, primary key
#  description         :text             not null
#  event_id            :bigint           not null
#  speakers            :string
#  title               :string           not null
#  video_url           :string           default("unknown"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_talks_on_event_id             (event_id)
#
FactoryBot.define do
  factory :talk do
    sequence :description do |n|
      "description_#{n}"
    end
    sequence :title do |n|
      "title_#{n}"
    end
    sequence :speakers do |n|
      "Speaker Name #{n}"
    end
    event factory: :database_event
  end
end
