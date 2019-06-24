FactoryBot.define do
  factory :membership do
    user
    joined_at { 1.day.ago }
    left_at { nil }
  end
end
