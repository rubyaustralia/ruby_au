class CreateRsvps < ActiveRecord::Migration[5.2]
  def change
    create_table :rsvps do |t|
      t.references :rsvp_event, null: false, foreign_key: true
      t.references :membership, null: false, foreign_key: true
      t.string     :status,     null: false, default: 'unknown'
      t.string     :token,      null: false
      t.timestamps
    end

    add_index :rsvps, :token, unique: true
  end
end
