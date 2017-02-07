class RemoveSomeAttributesFromProfiles < ActiveRecord::Migration[5.0]
  def up
    remove_column :profiles, :twitter_url
    remove_column :profiles, :github_url
    remove_column :profiles, :website_url
    remove_column :profiles, :biography
    remove_column :profiles, :display_profile
  end

  def down
    add_column :profiles, :twitter_url, :string
    add_column :profiles, :github_url, :string
    add_column :profiles, :website_url, :string
    add_column :profiles, :biography, :text
    add_column :profiles, :display_profile, :boolean, default: false, null: false
  end
end
