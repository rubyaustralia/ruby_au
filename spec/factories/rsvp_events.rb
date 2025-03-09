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
FactoryBot.define do
  factory :rsvp_event do
    title      { "AGM" }
    happens_at { 1.month.from_now }
  end
end
