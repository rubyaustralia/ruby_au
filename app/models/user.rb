class User < ApplicationRecord
  include Clearance::User
  has_one :profile, dependent: :destroy

  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
