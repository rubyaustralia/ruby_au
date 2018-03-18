require 'rails_helper'

RSpec.describe User do
  it "is valid by default" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is not valid without an email" do
    user = User.new(email: nil)
    expect(user).to_not be_valid
  end

  it "is not valid with a duplicate email" do
    User.new(email: 'test@example.com')
    user = User.new(email: 'test@example.com')
    expect(user).to_not be_valid
  end

  it "is not valid without a password" do
    user = User.new(password: nil)
    expect(user).to_not be_valid
  end

  describe ".visible_for_user" do
    it "returns the matching users profile or visible profiles" do
      current_user = FactoryGirl.create(:user)

      visible_profiles = create_list(:user, 2, :visible)
      invisible_profiles = create_list(:user, 2)

      expect(User.visible_for_user(current_user)).to \
        match_array([*visible_profiles, current_user])
    end
  end

  describe '.send_email_confirmation' do
    let(:user) { FactoryGirl.build(:user) }

    it 'regenerates token and send confirmation email' do
      expect(user).to receive(:regenerate_token)
      expect { user.send_email_confirmation }
        .to change { ActionMailer::Base.deliveries.count }.by(1)
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
      let(:user) { User.new(email_confirmed: true, joined_at: Time.now) }
      it 'returns with error' do
        expect(user).to_not receive(:update!)
        user.create_membership
        expect(user.errors[:base]).to include(/already a member/)
      end
    end

    context 'when email confirmed' do
      let(:user) { FactoryGirl.build(:user, email_confirmed: true) }
      it 'turn user into member' do
        user.create_membership
        expect(user.errors[:base]).to be_empty
        expect(user.reload.is_member?).to eq true
      end
    end
  end

  describe '.cancel_membership' do
    let(:user) { FactoryGirl.create(:user) }

    it 'cancals the membership of the user' do
      user.cancel_membership
      expect(user.is_member?).to eq false
    end
  end

  describe '.is_member?' do
    context 'has not joined' do
      it 'is a not member' do
        expect(User.new(joined_at: nil).is_member?).to eq false
      end
    end

    context 'joined user' do
      it 'is a member' do
        expect(User.new(joined_at: Time.now).is_member?).to eq true
      end
    end

    context 'joined and left' do
      it 'is a not member' do
        expect(User.new(joined_at: Time.now, left_at: Time.now).is_member?).to eq false
      end
    end
  end
end
