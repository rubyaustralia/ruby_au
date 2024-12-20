FactoryBot.define do
  factory :email do
    association :user
    email { Faker::Internet.email }

    trait :confirmed do
      confirmed_at { Time.current }
    end
  end
end
