FactoryBot.define do
  factory :imported_member do
    sequence :full_name do |n|
      "full_name_#{n}"
    end
    sequence :email do |n|
      "user#{n}@example.com"
    end

    data { { "sources" => ["Ruby Retreat"] } }
  end
end
