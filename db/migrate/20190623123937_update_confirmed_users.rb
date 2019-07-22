class UpdateConfirmedUsers < ActiveRecord::Migration[5.2]
  def up
    User.where(email_confirmed: true).update_all(confirmed_at: Time.current)
  end
end
