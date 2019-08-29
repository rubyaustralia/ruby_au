class AddMailingListsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :mailing_lists, :json, default: {}, null: false
  end
end
