class UpdateConfirmedUsers < ActiveRecord::Migration[5.2]
  def up
    User.where(email_confirmed: true).update(confirmed_at: Time.current)
  end
end
