class CreateAccessRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :access_requests do |t|
      t.string :name, null: false
      t.text :reason
      t.date :requested_on, null: false
      t.date :viewed_on
      t.references :recorder, foreign_key: { to_table: :users }
      t.timestamps null: false
    end
  end
end
