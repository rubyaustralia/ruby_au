class MergeProfileToUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :preferred_name, :string
    add_column :users, :full_name, :string
    add_column :users, :mailing_list, :boolean, default: false, null: false
    add_column :users, :visible, :boolean, default: false, null: false

    execute <<-SQL
      UPDATE users 
      SET 
      preferred_name = profiles.preferred_name,
      full_name = profiles.full_name,
      mailing_list = profiles.mailing_list,
      visible = profiles.visible
      FROM profiles 
      where users.id = profiles.user_id
    SQL

    drop_table :profiles
  end

  def down
    create_table "profiles" do |t|
      t.integer  "user_id",                        null: false
      t.string   "preferred_name"
      t.string   "full_name"
      t.datetime "created_at",                     null: false
      t.datetime "updated_at",                     null: false
      t.boolean  "mailing_list",   default: false, null: false
      t.boolean  "visible",        default: false, null: false
      t.index ["user_id"], name: "index_profiles_on_user_id", using: :btree
    end

    execute <<-SQL
      INSERT INTO profiles (user_id, preferred_name, full_name, created_at, updated_at,
        mailing_list, visible)
      SELECT users.id, users.preferred_name, users.full_name, users.created_at, 
        users.updated_at, users.mailing_list, users.visible
      FROM users
    SQL

    remove_column :users, :preferred_name
    remove_column :users, :full_name
    remove_column :users, :mailing_list
    remove_column :users, :visible
  end
end
