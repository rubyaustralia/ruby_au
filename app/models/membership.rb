class Membership < ApplicationRecord
  belongs_to :user

  validates :joined_at, presence: true
  validate :single_current_membership, on: :create

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
