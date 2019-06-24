FactoryBot.define do
  factory :user do
    sequence :full_name do |n|
      "full_name_#{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password { "password" }
    confirmed_at { 1.minute.ago }
    address { '42 Wallaby Way, Sydney' }

    trait :visible do
      visible { true }
    end
    trait :invisible do
      visible { false }
    end

    after(:create) do |user, _evaluator|
      user.memberships.create joined_at: Time.current if user.confirmed_at
    end
  end
end
