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
    visible { true }
    skip_subscriptions { true }
    mailing_lists { {} }

    trait :visible do
      visible { true }
    end
    trait :invisible do
      visible { false }
    end

    trait :committee do
      committee { true }
    end

    trait :deactivated do
      deactivated_at { Time.current }

      after :create do |user, _options|
        user.memberships.current.first&.update! left_at: Time.current
      end
    end
  end
end
