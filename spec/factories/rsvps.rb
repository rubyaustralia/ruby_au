# == Schema Information
#
# Table name: rsvps
#
#  id                :bigint           not null, primary key
#  proxy_assigned_at :datetime
#  proxy_name        :string
#  proxy_signature   :text
#  status            :string           default("unknown"), not null
#  token             :string           not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  membership_id     :bigint           not null
#  rsvp_event_id     :bigint           not null
#
# Indexes
#
#  index_rsvps_on_membership_id  (membership_id)
#  index_rsvps_on_rsvp_event_id  (rsvp_event_id)
#  index_rsvps_on_token          (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (membership_id => memberships.id)
#  fk_rails_...  (rsvp_event_id => rsvp_events.id)
#
FactoryBot.define do
  factory :rsvp do
    rsvp_event
    membership { FactoryBot.create(:user).memberships.first }
  end
end
