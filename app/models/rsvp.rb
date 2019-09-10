# frozen_string_literal: true

class Rsvp < ApplicationRecord
  STATUSES = %w[unknown yes no].freeze

  belongs_to :rsvp_event
  belongs_to :membership

  validates :status, presence: true, inclusion: { in: STATUSES }
  validates :token, presence: true, uniqueness: true

  before_validation :set_token, on: :create

  private

  def set_token
    self.token ||= SecureRandom.uuid
  end
end
