require "rails_helper"

describe MembershipsController do
  describe 'create' do
    let(:user) { FactoryGirl.create(:user) }
    subject { post :create }

    it 'send confirmation email and redirect to profile page' do
      sign_in user
      expect(user).to receive(:create_membership)
      subject
      expect(response).to redirect_to profile_path
    end
  end

  describe 'destroy' do
    let(:user) { FactoryGirl.create(:user) }
    subject { delete :destroy }

    it 'send confirmation email and redirect to profile page' do
      sign_in user
      expect(user).to receive(:cancel_membership)
      subject
      expect(response).to redirect_to profile_path
    end
  end
end
