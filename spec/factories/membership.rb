FactoryBot.define do
  factory :membership do
    user
    joined_at { Time.current }
  end
end
