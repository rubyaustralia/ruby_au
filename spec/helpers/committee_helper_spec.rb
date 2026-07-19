require 'rails_helper'

RSpec.describe CommitteeHelper, type: :helper do
  describe '#presidents' do
    it 'returns a list of presidents' do
      expect(helper.presidents).not_to be_empty
    end

    it 'has Keith as the oldest president' do
      expect(helper.presidents[-1][:name]).to eq('Keith Pitty')
    end

    it 'is 2012/06/16 when the second oldest president term starts' do
      expect(helper.presidents[-2][:start][0]).to eq('2012-06-16')
    end
  end
end
