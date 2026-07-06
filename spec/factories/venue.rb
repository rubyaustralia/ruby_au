# == Schema Information
#
# Table name: venues
#
#  id              :bigint           not null, primary key
#  address         :string           not null
#  google_maps_url :string           not null
#  name            :string           not null
#  notes           :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
FactoryBot.define do
  factory :venue do
    sequence :name do |n|
      "venue_name_#{n}"
    end
    google_maps_url { 'https://maps.app.goo.gl/' }
    address { "271 Collins St, Melbourne" }
  end
end
