class RemoveEmailFromUsers < ActiveRecord::Migration[8.1]
  def change
    remove_column :users, :email, :string
  end
end
