class AddUnsubscribedAtToImportedMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :imported_members, :unsubscribed_at, :datetime
    add_index :imported_members, :unsubscribed_at
    add_index :imported_members, :contacted_at
  end
end
