# == Schema Information
#
# Table name: memberships
#
#  id         :bigint           not null, primary key
#  joined_at  :datetime         not null
#  left_at    :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_memberships_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
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
