# == Schema Information
#
# Table name: elections
#
#  id          :bigint           not null, primary key
#  closed_at   :datetime
#  opened_at   :datetime
#  point_scale :integer          default(10), not null
#  title       :string           not null
#  vacancies   :integer          default(1), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Election < ApplicationRecord
  has_many :nominations, dependent: :restrict_with_error
  has_many :votes, through: :nominations
  has_many :nominated_candidates, through: :nominations, source: :nominee

  scope :open, -> { where('opened_at <= ?', Time.current).where('closed_at > ? OR closed_at IS NULL', Time.current) }
  scope :closed, -> { where('closed_at <= ?', Time.current) }

  validates_presence_of :title, :point_scale, :vacancies

  def open?
    opened_at.past? && !closed?
  end

  def closed?
    closed_at.past?
  end

  def elected_users
    if voting_required?
      top_scoring_candidates
    else
      nominated_candidates
    end
  end

  private

  def voting_required?
    nominated_candidates.count > vacancies
  end

  def top_scoring_candidates
    User.where(
      id: nominations
        .joins(:votes)
        .group('nominations.id')
        .order('SUM(votes.score) DESC')
        .limit(vacancies)
        .pluck(:nominee_id)
    )
  end
end
