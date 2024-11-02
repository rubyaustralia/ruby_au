require 'rails_helper'

RSpec.describe User, type: :model do
  let(:unconfirmed_user) { create(:user, confirmed_at: nil) }
  let(:committee_user) { create(:user, committee: true) }

  describe '.committee' do
    before do
      committee_user
      unconfirmed_user
    end
    it 'returns users who are part of the committee' do
      expect(User.committee).to include(committee_user)
      expect(User.committee).not_to include(unconfirmed_user)
    end
  end
end
