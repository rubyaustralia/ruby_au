class CreatePosts < ActiveRecord::Migration[8.0]
  def change
    create_table :posts do |t|
      t.references :user
      t.string :title
      t.string :slug
      t.text :content
      t.integer :status
      t.datetime :published_at
      t.integer :category
      t.datetime :publish_scheduled_at
      t.datetime :archieved_at

      t.timestamps
    end
  end
end
