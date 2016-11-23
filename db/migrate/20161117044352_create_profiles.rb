class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false
      t.string :preferred_name
      t.string :full_name

      t.string :twitter_url
      t.string :github_url
      t.string :website_url

      t.text :biography
      t.boolean :display_profile, null: false, default: false

      t.timestamps
    end
  end
end
