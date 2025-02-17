FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }
    category { :news }
    association :user

    trait :draft do
      status { :draft }
      publish_scheduled_at { nil }
    end

    trait :publishable do
      status { :draft }
      publish_scheduled_at { 1.day.from_now }
    end

    trait :scheduled do
      status { :scheduled }
      publish_scheduled_at { 1.day.from_now }
    end

    trait :published do
      status { :published }
      published_at { Time.current }
    end
  end
end
