FactoryBot.define do
  factory :user do
    sequence :preferred_name do |n|
      "preferred_name_#{n}"
    end
    sequence :full_name do |n|
      "full_name_#{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end

    password { "password" }
    email_confirmed { true }

    trait :visible do
      visible { true }
    end
    trait :invisible do
      visible { false }
    end

    after(:create) do |user, evaluator|
      user.update email_confirmed: true if evaluator.email_confirmed.nil? || evaluator.email_confirmed
    end
  end
end
