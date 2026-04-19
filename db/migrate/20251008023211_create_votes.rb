class CreateVotes < ActiveRecord::Migration[8.0]
  def change
    create_table :votes do |t|
      t.integer :score, null: false
      t.references :voter, null: false, foreign_key: { to_table: :users }
      t.references :votable, null: false, polymorphic: true

      t.timestamps
    end

    add_index :votes, [:voter_id, :votable_id], unique: true
  end
end
