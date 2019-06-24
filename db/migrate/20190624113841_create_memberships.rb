class CreateMemberships < ActiveRecord::Migration[5.2]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true, null: false
      t.datetime :joined_at, null: false
      t.datetime :left_at
      t.timestamps null: false
    end
  end
end
