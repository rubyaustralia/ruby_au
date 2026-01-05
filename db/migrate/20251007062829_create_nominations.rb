class CreateNominations < ActiveRecord::Migration[8.0]
  def change
    create_table :nominations do |t|
      t.references :election, null: false, foreign_key: true
      t.references :nominee, null: false, foreign_key: { to_table: :users }
      t.references :nominated_by, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :nominations, [:election_id, :nominee_id], unique: true
  end
end
