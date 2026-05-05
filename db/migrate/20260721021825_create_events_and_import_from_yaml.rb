class CreateEventsAndImportFromYaml < ActiveRecord::Migration[8.1]
  def change

    create_table :venues do |t|
      t.string :name, null: false
      t.string :google_maps_url, null: false
      t.string :address, null: false
      t.text :notes
      t.timestamps
    end

    create_table :events do |t|
      t.date :date, null: false
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.string :name, null: false
      t.text :description, null: false
      t.string :slug, null: false
      t.string :event_type, null: false
      t.string :region, null: false
      t.references :venue
      t.string :registration_url
      t.timestamps
    end

    create_table :talks do |t|
      t.references :event, null: false
      t.string :title, null: false
      t.text :description, null: false
      t.string :speakers
      t.string :video_url, default: "unknown", null: false
      t.timestamps
    end

    change_table :users do |t|
      t.boolean :meetup_admin, default: false, null: false
    end
  end
end
