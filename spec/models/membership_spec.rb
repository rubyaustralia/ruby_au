require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe "#valid?" do
    let(:user) { create :user }

    it 'does not let a second current membership exist for a user' do
      user

      membership = Membership.new user: user, joined_at: 1.minute.ago
      expect(membership).to_not be_valid
    end
  end
end
