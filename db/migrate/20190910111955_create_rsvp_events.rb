class CreateRsvpEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :rsvp_events do |t|
      t.string   :title,      null: false
      t.datetime :happens_at, null: false
      t.timestamps
    end
  end
end
