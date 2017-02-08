class AddMailingListToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :mailing_list, :boolean, default: false, null: false
  end
end
