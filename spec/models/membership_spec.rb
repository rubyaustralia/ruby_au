require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe "#valid?" do
    let(:user) { create :user }

    it 'does not let a second current membership exist for a user' do
      user

      membership = described_class.new user: user, joined_at: 1.minute.ago
      expect(membership).not_to be_valid
    end
  end
end
