require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe "#valid?" do
    it 'does not let a second current membership exist for a user' do
      existing = create :membership

      membership = build :membership, user: existing.user
      expect(membership).to_not be_valid
    end
  end
end
