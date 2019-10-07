class CampaignDelivery < ApplicationRecord
  belongs_to :campaign
  belongs_to :membership
end
