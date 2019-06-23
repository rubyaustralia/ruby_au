require 'rails_helper'

RSpec.describe User do
  describe ".visible_for_user" do
    it "returns the matching users profile or visible profiles" do
      current_user = FactoryBot.create(:user)

      visible_profiles = create_list(:user, 2, :visible)
      invisible_profiles = create_list(:user, 2)

      expect(User.visible_for_user(current_user)).to match_array([*visible_profiles, current_user])
      expect(User.visible_for_user(current_user)).to_not match_array(invisible_profiles)
    end
  end

  describe '.create_membership' do
    context 'when email not confirmed' do
      let(:user) { User.new(email_confirmed: false) }
      it 'returns with error' do
        expect(user).to_not receive(:update!)
        user.create_membership
        expect(user.errors[:base]).to include(/verify your email/)
      end
    end

    context 'when user is already a member' do
      let(:user) { User.new(email_confirmed: true, joined_at: Time.current) }
      it 'returns with error' do
        expect(user).to_not receive(:update!)
        user.create_membership
        expect(user.errors[:base]).to include(/already a member/)
      end
    end

    context 'when email confirmed' do
      let(:user) { FactoryBot.build(:user, email_confirmed: true) }
      it 'turn user into member' do
        user.create_membership
        expect(user.errors[:base]).to be_empty
        expect(user.reload.member?).to eq true
      end
    end
  end

  describe '.cancel_membership' do
    let(:user) { FactoryBot.create(:user) }

    it 'cancals the membership of the user' do
      user.cancel_membership
      expect(user.member?).to eq false
    end
  end

  describe '.member?' do
    context 'has not joined' do
      it 'is a not member' do
        expect(User.new(joined_at: nil).member?).to eq false
      end
    end

    context 'joined user' do
      it 'is a member' do
        expect(User.new(joined_at: Time.current).member?).to eq true
      end
    end

    context 'joined and left' do
      it 'is a not member' do
        expect(User.new(joined_at: Time.current, left_at: Time.current).member?).to eq false
      end
    end
  end
end
