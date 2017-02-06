class Profile < ApplicationRecord
  belongs_to :user
  validates :display_profile, inclusion: { in: [true, false] }
end
