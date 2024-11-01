FactoryBot.define do
  factory :campaign_delivery do
    association :campaign
    association :membership
    delivered_at { Time.current }
  end
end
