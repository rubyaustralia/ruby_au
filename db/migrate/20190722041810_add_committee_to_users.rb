class AddCommitteeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :committee, :boolean, default: false, null: false
  end
end
