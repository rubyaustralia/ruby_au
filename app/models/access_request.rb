# == Schema Information
#
# Table name: access_requests
#
#  id           :bigint           not null, primary key
#  name         :string           not null
#  reason       :text
#  requested_on :date             not null
#  viewed_on    :date
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  recorder_id  :bigint
#
# Indexes
#
#  index_access_requests_on_recorder_id  (recorder_id)
#
# Foreign Keys
#
#  fk_rails_...  (recorder_id => users.id)
#
class AccessRequest < ApplicationRecord
  belongs_to :recorder, class_name: "User"

  validates :name, presence: true
  validates :requested_on, presence: true
end
