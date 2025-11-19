# == Schema Information
#
# Table name: votes
#
#  id            :bigint           not null, primary key
#  score         :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  nomination_id :bigint           not null
#  voter_id      :bigint           not null
#
# Indexes
#
#  index_votes_on_nomination_id               (nomination_id)
#  index_votes_on_voter_id                    (voter_id)
#  index_votes_on_voter_id_and_nomination_id  (voter_id,nomination_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (voter_id => users.id)
#
class Vote < ApplicationRecord
  belongs_to :nomination
  belongs_to :voter, class_name: 'User'

  validate :election_must_be_open_validation

  private

  def election_must_be_open_validation
    errors.add(:base, "Election is not currently open") unless nomination.election.open?
  end
end
