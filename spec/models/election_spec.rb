# == Schema Information
#
# Table name: elections
#
#  id            :bigint           not null, primary key
#  called_at     :datetime
#  closed_at     :datetime
#  maximum_score :integer          default(5), not null
#  minimum_score :integer          default(-5), not null
#  opened_at     :datetime
#  title         :string           not null
#  vacancies     :integer          default(1), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
require 'rails_helper'

RSpec.describe Election, type: :model do
  describe 'scopes' do
    let!(:open_election) { create(:election, :open) }
    let!(:closed_election) { create(:election, :closed) }
    let!(:pending_election) { create(:election, :pending) }
    let!(:called_election) { create(:election, :open, called_at: Time.current) }

    describe '.open' do
      it 'includes elections that are currently open and not called' do
        expect(described_class.open).to include(open_election)
        expect(described_class.open).not_to include(closed_election, pending_election, called_election)
      end
    end

    describe '.closed' do
      it 'includes elections that are closed or called' do
        expect(described_class.closed).to include(closed_election, called_election)
        expect(described_class.closed).not_to include(open_election, pending_election)
      end
    end
  end

  describe '#open?' do
    it 'is open if opened_at is in the past and closed_at is in the future' do
      election = build(:election, opened_at: 1.day.ago, closed_at: 1.day.from_now)
      expect(election).to be_open
    end

    it 'is not open if called_at is present' do
      election = build(:election, opened_at: 1.day.ago, closed_at: 1.day.from_now, called_at: Time.current)
      expect(election).not_to be_open
    end
  end

  describe '#call!' do
    it 'sets called_at to current time' do
      election = create(:election, :open)
      expect { election.call! }.to change { election.called_at }.from(nil)
      expect(election).to be_closed
    end
  end

  describe '#voting_completed_for?' do
    let(:user) { create(:user) }
    let(:election) { create(:election, :open) }
    let(:nomination) { create(:nomination, election: election) }

    it 'returns false if user has not voted' do
      expect(election).not_to be_voting_completed_for(user)
    end

    it 'returns true if user has voted' do
      create(:vote, voter: user, votable: nomination)
      expect(election).to be_voting_completed_for(user)
    end
  end

  describe '#elected_users' do
    subject(:elected_users) { election.elected_users }

    context 'when there are sufficient vacancies for nominees' do
      let(:election) { create(:election, :open, vacancies: 3) }
      let(:first_nomination) { create(:nomination, election: election) }
      let(:second_nomination) { create(:nomination, election: election) }

      it 'returns all the nominated users' do
        expect(elected_users).to contain_exactly(
          first_nomination.nominee,
          second_nomination.nominee,
        )
      end
    end

    context 'when there are more nominees than vacancies' do
      let(:election) { create(:election, :open, vacancies: 2, point_scale: 5) }
      let(:nomination_amir) { create(:nomination, election: election) }
      let(:nomination_billie) { create(:nomination, election: election) }
      let(:nomination_carol) { create(:nomination, election: election) }
      let(:nomination_denise) { create(:nomination, election: election) }

      before do
        create(:vote, :for_nomination, votable: nomination_amir, score: 3)
        create(:vote, :for_nomination, votable: nomination_amir, score: 1)

        create(:vote, :for_nomination, votable: nomination_billie, score: 2)
        create(:vote, :for_nomination, votable: nomination_billie, score: 8)
        create(:vote, :for_nomination, votable: nomination_billie, score: 2)

        create(:vote, :for_nomination, votable: nomination_carol, score: 4)
        create(:vote, :for_nomination, votable: nomination_carol, score: 10)

        create(:vote, :for_nomination, votable: nomination_denise, score: 9)
        create(:vote, :for_nomination, votable: nomination_denise, score: 1)
        create(:vote, :for_nomination, votable: nomination_denise, score: 8)
      end

      it 'returns the top scoring candidates required to fill the vacancies' do
        expect(elected_users).to contain_exactly(
          nomination_carol.nominee,
          nomination_denise.nominee,
        )
      end
    end
  end
end
