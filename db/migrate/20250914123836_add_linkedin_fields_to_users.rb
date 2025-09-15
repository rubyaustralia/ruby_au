class AddLinkedinFieldsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :linkedin_url, :string
    add_column :users, :seeking_work, :boolean, default: false, null: false
  end
end
