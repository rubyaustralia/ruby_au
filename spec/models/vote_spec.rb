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
require 'rails_helper'

RSpec.describe Vote, type: :model do
  context "when the election has already finished" do
    let(:election) { create(:election, :closed) }
    let(:nomination) { create(:nomination, election: election) }
    let(:vote) { create(:vote, votable: nomination) }

    it "raises a validation error" do
      expect { vote }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context "when the user has already voted" do
    let(:election) { create(:election, :open) }
    let(:voter) { create(:user) }
    let(:nomination) { create(:nomination, election: election) }
    let(:vote) { create(:vote, voter: voter, votable: nomination) }

    before do
      create(:vote, voter: voter, votable: nomination)
    end

    it "raises a validation error" do
      expect { vote }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
