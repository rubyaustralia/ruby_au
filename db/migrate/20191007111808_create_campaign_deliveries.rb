class CreateCampaignDeliveries < ActiveRecord::Migration[5.2]
  def change
    create_table :campaign_deliveries do |t|
      t.references :campaign, foreign_key: true
      t.references :membership, foreign_key: true
      t.datetime :delivered_at, null: false
      t.timestamps
    end
  end
end
