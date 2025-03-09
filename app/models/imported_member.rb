# == Schema Information
#
# Table name: imported_members
#
#  id              :bigint           not null, primary key
#  contacted_at    :datetime
#  data            :json             not null
#  email           :string           not null
#  full_name       :string           not null
#  token           :string           not null
#  unsubscribed_at :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_imported_members_on_contacted_at     (contacted_at)
#  index_imported_members_on_email            (email)
#  index_imported_members_on_token            (token) UNIQUE
#  index_imported_members_on_unsubscribed_at  (unsubscribed_at)
#
class ImportedMember < ApplicationRecord
  scope :uncontacted, -> { where(contacted_at: nil) }
  scope :subscribed,  -> { where(unsubscribed_at: nil) }
  scope :contactable, -> { uncontacted.subscribed }

  validates :full_name, presence: { allow_blank: true }
  validates :email, presence: true
  validates :token, presence: true, uniqueness: true

  before_validation :set_token, on: :create

  private

  def set_token
    self.token ||= SecureRandom.uuid
  end
end
