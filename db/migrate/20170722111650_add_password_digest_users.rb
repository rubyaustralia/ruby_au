class AddPasswordDigestUsers < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :password_digest, :string
    add_column :users, :token, :string

    User.find_each do |user|
      user.full_name ||= '<Missing>'
      user.preferred_name ||= '<Missing>'
      user.password = SecureRandom.hex
      user.regenerate_token
    end

    remove_column :users, :encrypted_password
    remove_column :users, :confirmation_token
    remove_column :users, :remember_token
  end

  def down
    remove_column :users, :password_digest, :string
    remove_column :users, :token, :string

    add_column :users, :encrypted_password, :string, limit: 128
    add_column :users, :confirmation_token, :string, limit: 128
    add_column :users, :remember_token, :string, limit: 128
  end
end
