class AccessRequest < ApplicationRecord
  belongs_to :recorder, class_name: "User"

  validates :name, presence: true
  validates :requested_on, presence: true
end
