class Email < ApplicationRecord
  attr_accessor :skip_trigger_after_confirmation

  belongs_to :user

  validates :email,
            presence: true,
            uniqueness: true,
            format: { with: Devise.email_regexp }

  after_save :trigger_after_confirmation

  delegate :full_name, :address, to: :user

  private

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_now
  end

  def trigger_after_confirmation
    return unless !skip_trigger_after_confirmation && saved_change_to_confirmed_at?

    email_update = saved_change_to_email? && email_before_last_save.present?
    user.update_mailing_list_and_memberships(email_update: email_update)
  end
end
