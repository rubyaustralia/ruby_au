class Email < ActiveRecord::Base
  belongs_to :user

  validates :email, presence: true, uniqueness: true

  after_save :trigger_after_confirmation, if: :saved_change_to_confirmed_at?

  delegate :full_name, :address, to: :user

  private

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_now
  end

  def trigger_after_confirmation
    email_update = saved_change_to_email? && email_before_last_save.present?
    user.update_mailing_list_and_memberships(email_update: email_update)
  end
end
