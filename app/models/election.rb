# == Schema Information
#
# Table name: elections
#
#  id          :bigint           not null, primary key
#  closed_at   :datetime
#  opened_at   :datetime
#  point_scale :integer          default(10), not null
#  position    :string           not null
#  vacancies   :integer          default(1), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Election < ApplicationRecord
  has_paper_trail

  has_many :nominations
  has_many :votes, through: :nominations
  has_many :nominated_candidates, through: :nominations, source: :nominee

  def open?
    opened_at.present? && opened_at <= Time.current && (closed_at.nil? || closed_at > Time.current)
  end

  def elected_users
    if nominated_candidates.count > vacancies
      top_scoring_candidates
    else
      nominated_candidates
    end
  end

  private

  def top_scoring_candidates
    User.where(id:
      nominations
        .joins(:votes)
        .group('nominations.id')
        .order('SUM(votes.score) DESC')
        .limit(vacancies)
        .pluck(:nominee_id)
    )
  end
end
