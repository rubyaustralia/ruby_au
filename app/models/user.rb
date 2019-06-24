class User < ApplicationRecord
  # Include devise modules. Others available are:
  # :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :validatable, :confirmable, :trackable

  has_many :memberships, dependent: :destroy

  validates :full_name, presence: true
  validates :address, presence: true

  def active_for_authentication?
    super && deactivated_at.nil?
  end

  protected

  def after_confirmation
    return if memberships.current.any?

    memberships.create joined_at: Time.current
  end
end
