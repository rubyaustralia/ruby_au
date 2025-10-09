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
    subject { election.elected_users }

    context 'when there are vacancies for nominees' do
      let(:election) { create(:election, :open, vacancies: 3) }
      let(:nomination_1) { create(:nomination, election: election) }
      let(:nomination_2) { create(:nomination, election: election) }

      it 'returns all the nominated users' do
        expect(subject).to contain_exactly(
          nomination_1.nominee,
          nomination_2.nominee,
        )
      end
    end

    context 'when there are more nominees than vacancies' do
      let(:election) { create(:election, :open, vacancies: 2, point_scale: 10) }
      let(:nomination_1) { create(:nomination, election: election) }
      let(:nomination_2) { create(:nomination, election: election) }
      let(:nomination_3) { create(:nomination, election: election) }
      let(:nomination_4) { create(:nomination, election: election) }

      before do
        create(:vote, nomination: nomination_1, score: 3)
        create(:vote, nomination: nomination_1, score: 1)

        create(:vote, nomination: nomination_2, score: 2)
        create(:vote, nomination: nomination_2, score: 8)
        create(:vote, nomination: nomination_2, score: 2)

        create(:vote, nomination: nomination_3, score: 4)
        create(:vote, nomination: nomination_3, score: 10)

        create(:vote, nomination: nomination_4, score: 9)
        create(:vote, nomination: nomination_4, score: 1)
        create(:vote, nomination: nomination_4, score: 8)
      end

      it 'returns the top scoring candidates required to fill the vacancies' do
        expect(subject).to contain_exactly(
          nomination_3.nominee,
          nomination_4.nominee,
        )
      end
    end
  end
end
