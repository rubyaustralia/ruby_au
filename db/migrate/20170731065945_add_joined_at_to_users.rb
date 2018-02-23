class AddJoinedAtToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :joined_at, :datetime, null: true
    add_column :users, :left_at, :datetime, null: true
    add_column :users, :email_confirmed, :boolean, default: false
  end
end
