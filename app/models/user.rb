class User < ApplicationRecord
  scope :visible_for_user, ->(user) { where(visible: true).or(where(id: user&.id)) }
  scope :members, -> { where('joined_at IS NOT NULL AND left_at is NULL') }

  validates :email,
    uniqueness: { case_sensitive: false },
    email_format: true
  validates :preferred_name, presence: true
  validates :full_name, presence: true

  before_save do
    self.email_confirmed = false if email_changed?
  end

  has_secure_password
  has_secure_token

  def send_email_confirmation
    regenerate_token
    UserMailer.confirm_email(self).deliver_now
    true
  end

  def create_membership
    unless email_confirmed?
      errors.add :base, 'Please verify your email address'
      return
    end

    if is_member?
      errors.add :base, 'You are already a member'
      return
    end

    update!(joined_at: Time.now, left_at: nil)
  end

  def cancel_membership
    update!(left_at: Time.now)
  end

  def is_member?
    joined_at.present? && left_at.nil?
  end
end
