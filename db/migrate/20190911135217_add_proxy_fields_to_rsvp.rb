class AddProxyFieldsToRsvp < ActiveRecord::Migration[5.2]
  def change
    change_table :rsvps, bulk: true do |t|
      t.string :proxy_name, null: true
      t.text :proxy_signature
      t.datetime :proxy_assigned_at
    end
  end
end
