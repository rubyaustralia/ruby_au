class Profile < ApplicationRecord
  belongs_to :user

  scope :visible_for_user, ->(user) { where(visible: true).or(where(user: user)) }
end
