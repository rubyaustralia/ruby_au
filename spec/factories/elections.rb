# == Schema Information
#
# Table name: elections
#
#  id          :bigint           not null, primary key
#  closed_at   :datetime
#  opened_at   :datetime
#  point_scale :integer          default(10), not null
#  position    :string           not null
#  vacancies   :integer          default(1), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
FactoryBot.define do
  factory :election do
    position { 'President' }
    closed_at { nil }
    opened_at { nil }
    point_scale { 10 }
    vacancies { 1 }

    trait :open do
      opened_at { 1.week.ago }
      closed_at { 1.week.from_now }
    end

    trait :closed do
      opened_at { 1.month.ago }
      closed_at { 1.day.ago }
    end

    trait :pending do
      opened_at { 1.week.from_now }
    end
  end
end
