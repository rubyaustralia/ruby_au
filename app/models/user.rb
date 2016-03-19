class User < ApplicationRecord
  include Clearance::User
  validates :email, presence: true, uniqueness: { case_sensitive: false }
end
