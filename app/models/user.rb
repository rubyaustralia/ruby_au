class User < ApplicationRecord
  # Include devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :trackable

  scope :visible_for_user, ->(user) { where(visible: true).or(where(id: user&.id)) }
  scope :members, -> { where('joined_at IS NOT NULL AND left_at is NULL') }

  validates :preferred_name, presence: true
  validates :full_name, presence: true

  def create_membership
    unless email_confirmed?
      errors.add :base, 'Please verify your email address'
      return
    end

    if member?
      errors.add :base, 'You are already a member'
      return
    end

    update!(joined_at: Time.current, left_at: nil)
  end

  def cancel_membership
    update!(left_at: Time.current)
  end

  def member?
    joined_at.present? && left_at.nil?
  end
end
