# == Schema Information
#
# Table name: campaign_deliveries
#
#  id            :bigint           not null, primary key
#  delivered_at  :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  campaign_id   :bigint
#  membership_id :bigint
#
# Indexes
#
#  index_campaign_deliveries_on_campaign_id    (campaign_id)
#  index_campaign_deliveries_on_membership_id  (membership_id)
#
# Foreign Keys
#
#  fk_rails_...  (campaign_id => campaigns.id)
#  fk_rails_...  (membership_id => memberships.id)
#
class CampaignDelivery < ApplicationRecord
  belongs_to :campaign
  belongs_to :membership
end
