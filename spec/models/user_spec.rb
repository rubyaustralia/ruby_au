require 'rails_helper'

RSpec.describe User, type: :model do
  let(:unconfirmed_user) { create(:user, confirmed_at: nil) }
  let(:committee_user) { create(:user, committee: true) }
  let(:user) { create(:user) }

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

  describe '#emails' do
    it 'can have multiple emails' do
      user.emails.create!(email: 'test1@example.com')
      user.emails.create!(email: 'test2@example.com')
      expect(user.emails.count).to eq(3)
    end
  end

  describe '#active_for_authentication?' do
    it 'returns true if the user is not deactivated' do
      expect(user.active_for_authentication?).to be_truthy
    end

    it 'returns false if the user is deactivated' do
      user.deactivated_at = Time.current
      expect(user.active_for_authentication?).to be_falsey
    end
  end

  describe '#deactivated?' do
    it 'returns false if the user is not deactivated' do
      expect(user.deactivated?).to be_falsey
    end

    it 'returns true if the user is deactivated' do
      user.deactivated_at = Time.current
      expect(user.deactivated?).to be_truthy
    end
  end
end
