# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  joined_at  :datetime         not null
#  left_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_memberships_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Membership < ApplicationRecord
  belongs_to :user
  has_many :rsvps, dependent: :destroy

  validates :joined_at, presence: true
  validate :single_current_membership

  scope :current, -> { where(left_at: nil) }
  scope :visible, -> { joins(:user).where(users: { visible: true }) }

  delegate :full_name, :email, :address, to: :user

  private

  def single_current_membership
    return if left_at.present?

    existing = self.class.where(left_at: nil, user: user)
    existing = existing.where.not(id: id) if persisted?

    errors.add(:base, "A current membership for the user already exists") if existing.any?
  end
end
