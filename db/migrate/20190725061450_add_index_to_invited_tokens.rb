class AddIndexToInvitedTokens < ActiveRecord::Migration[5.2]
  def change
    add_index :imported_members, :token, unique: true
  end
end
