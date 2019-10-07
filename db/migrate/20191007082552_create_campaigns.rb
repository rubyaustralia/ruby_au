class CreateCampaigns < ActiveRecord::Migration[5.2]
  def change
    create_table :campaigns do |t|
      t.references :rsvp_event, null: true, foreign_key: true
      t.string :subject, null: false
      t.string :preheader, null: false
      t.text :content
      t.datetime :delivered_at
      t.timestamps
    end
  end
end
