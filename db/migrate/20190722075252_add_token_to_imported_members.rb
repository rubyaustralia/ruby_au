class AddTokenToImportedMembers < ActiveRecord::Migration[5.2]
  def change
    add_column :imported_members, :token, :string, null: false
  end
end
