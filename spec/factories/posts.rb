FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    association :user

    trait :published do
      published_at { Time.current }
    end
  end
end
