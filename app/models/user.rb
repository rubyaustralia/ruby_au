class User < ApplicationRecord
  include Clearance::User
  has_one :profile, dependent: :destroy

  validates :email, uniqueness: { case_sensitive: false }
end
