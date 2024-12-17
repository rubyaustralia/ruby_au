class CreateEmails < ActiveRecord::Migration[7.2]
  def change
    create_table :emails do |t|
      t.references :user, foreign_key: true
      t.string :email, null: false, index: { unique: true }
      t.boolean :primary, default: false, null: false

      ## Confirmable
      t.string :unconfirmed_email
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at

      t.timestamps
    end
  end
end
