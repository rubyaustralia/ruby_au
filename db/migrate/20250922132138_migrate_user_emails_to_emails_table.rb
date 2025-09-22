class MigrateUserEmailsToEmailsTable < ActiveRecord::Migration[8.0]
  def up
    User.find_each do |user|
      user.update_emails
    end
  end
end

