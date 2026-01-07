# == Schema Information
#
# Table name: votes
#
#  id           :bigint           not null, primary key
#  score        :integer          not null
#  votable_type :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  votable_id   :bigint           not null
#  voter_id     :bigint           not null
#
# Indexes
#
#  index_votes_on_votable                  (votable_type,votable_id)
#  index_votes_on_voter_id                 (voter_id)
#  index_votes_on_voter_id_and_votable_id  (voter_id,votable_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (voter_id => users.id)
#
class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :voter, class_name: 'User'

  validate :election_must_be_open_validation

  private

  def election_must_be_open_validation
    errors.add(:base, "Election is not currently open") if votable.is_a?(Nomination) && !votable.election.open?
  end
end
