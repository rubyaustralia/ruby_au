class CreateImports < ActiveRecord::Migration[5.0]
  def change
    create_table :imports do |t|
      t.string :name
      t.integer :user_id
      t.string :status
      t.text :csv
      t.jsonb :import_issues
      t.jsonb :imported_users
      t.jsonb :existing_users
      t.timestamps
    end
  end
end
