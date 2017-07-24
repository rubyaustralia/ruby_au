class User < ApplicationRecord
  scope :visible_for_user, ->(user) { where(visible: true).or(where(id: user&.id)) }

  validates :email,
    uniqueness: { case_sensitive: false },
    email_format: true
  validates :preferred_name, presence: true
  validates :full_name, presence: true

  has_secure_password
  has_secure_token
end
