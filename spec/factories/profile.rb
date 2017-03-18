FactoryGirl.define do
  factory :profile do
    sequence :preferred_name do |n|
      "preferred_name_#{n}"
    end

    sequence :full_name do |n|
      "full_name_#{n}"
    end
    user
    trait :visible do
      visible true
    end
    trait :invisible do
      visible false
    end
  end
end
