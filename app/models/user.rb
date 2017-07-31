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
    if !email_confirmed?
      errors.add :base, 'Please verify your email address'
    elsif is_member?
      errors.add :base, 'You are already a member'
    elsif !update(joined_at: Time.now, left_at: nil)
      errors.add :base, 'Your membership is not valid'
    end
  end

  def cancel_membership
    unless update(left_at: Time.now)
      errors.add :base, 'Your membership could not be cancelled'
    end
  end

  def is_member?
    joined_at && left_at.nil?
  end
end
