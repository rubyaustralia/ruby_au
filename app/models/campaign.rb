# == Schema Information
#
# Table name: campaigns
#
#  id            :bigint           not null, primary key
#  content       :text
#  delivered_at  :datetime
#  preheader     :string           not null
#  subject       :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  rsvp_event_id :bigint
#
# Indexes
#
#  index_campaigns_on_rsvp_event_id  (rsvp_event_id)
#
# Foreign Keys
#
#  fk_rails_...  (rsvp_event_id => rsvp_events.id)
#
class Campaign < ApplicationRecord
  belongs_to :rsvp_event, optional: true

  def delivered?
    delivered_at.present?
  end
end
