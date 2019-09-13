FactoryBot.define do
  factory :rsvp_event do
    title      { "AGM" }
    happens_at { 1.month.from_now }
  end
end
