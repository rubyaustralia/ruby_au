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
require 'rails_helper'

RSpec.describe Vote, type: :model do
  context 'when edited' do
    let(:vote) { create(:vote, score: 0) }

    before do
      vote.update(score: 10)
    end

    it 'leaves an audit trail of the update within the versions table' do
      expect(vote.versions.last.event).to eq('update')
    end

    it 'preserves the original data' do
      expect(vote.versions.last.reify.score).to eq(0)
    end
  end
end
