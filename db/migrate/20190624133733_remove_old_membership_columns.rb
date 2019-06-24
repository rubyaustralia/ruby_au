class RemoveOldMembershipColumns < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :joined_at, :datetime
    remove_column :users, :left_at, :datetime
  end
end
