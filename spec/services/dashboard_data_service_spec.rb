require 'rails_helper'

RSpec.describe DashboardDataService do
  let(:service) { described_class.new }

  describe '#call' do
    let!(:user) { create(:user) }

    # Assuming factories or direct creation
    before do
      # Current Month
      # The user from let!(:user) might already have a membership created via some callback
      Membership.where(user: user).delete_all
      Membership.create!(user: user, joined_at: Time.current)

      # Previous Month
      user_prev = create(:user)
      Membership.where(user: user_prev).delete_all
      Membership.create!(user: user_prev, joined_at: 1.month.ago.beginning_of_month + 1.day)

      # Two Months Ago
      user_two = create(:user)
      Membership.where(user: user_two).delete_all
      Membership.create!(user: user_two, joined_at: 2.months.ago.beginning_of_month + 1.day)

      # Earlier this year (if not already covered)
      if Time.current.month > 3
        user_ytd = create(:user)
        Membership.where(user: user_ytd).delete_all
        Membership.create!(user: user_ytd, joined_at: Time.current.beginning_of_year + 1.day)
      end
    end

    it 'includes new membership stats' do
      result = service.call

      expect(result[:new_members_current_month]).to eq(1)
      expect(result[:new_members_prev_month]).to eq(1)
      expect(result[:new_members_two_months_ago]).to eq(1)

      expected_ytd = Time.current.month > 3 ? 4 : 3
      expect(result[:new_members_ytd]).to eq(expected_ytd)
    end
  end
end
