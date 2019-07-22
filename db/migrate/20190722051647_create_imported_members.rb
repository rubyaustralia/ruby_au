class CreateImportedMembers < ActiveRecord::Migration[5.2]
  def change
    create_table :imported_members do |t|
      t.string :full_name, null: false
      t.string :email, null: false
      t.json :data, null: false, default: {}
      t.datetime :contacted_at
      t.timestamps null: false
    end

    add_index :imported_members, :email
  end
end
