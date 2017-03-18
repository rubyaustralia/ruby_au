class AddVisibleToProfiles < ActiveRecord::Migration[5.0]
  def change
    add_column :profiles, :visible, :boolean, default: false, null: false
  end
end
