FactoryBot.define do
  factory :rsvp do
    rsvp_event
    membership { FactoryBot.create(:user).memberships.first }
  end
end
