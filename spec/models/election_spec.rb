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
require 'rails_helper'

RSpec.describe Election, type: :model do
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
      let(:election) { create(:election, :open, vacancies: 2, point_scale: 10) }
      let(:nomination_amir) { create(:nomination, election: election) }
      let(:nomination_billie) { create(:nomination, election: election) }
      let(:nomination_carol) { create(:nomination, election: election) }
      let(:nomination_denise) { create(:nomination, election: election) }

      before do
        create(:vote, nomination: nomination_amir, score: 3)
        create(:vote, nomination: nomination_amir, score: 1)

        create(:vote, nomination: nomination_billie, score: 2)
        create(:vote, nomination: nomination_billie, score: 8)
        create(:vote, nomination: nomination_billie, score: 2)

        create(:vote, nomination: nomination_carol, score: 4)
        create(:vote, nomination: nomination_carol, score: 10)

        create(:vote, nomination: nomination_denise, score: 9)
        create(:vote, nomination: nomination_denise, score: 1)
        create(:vote, nomination: nomination_denise, score: 8)
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
