require "rails_helper"

describe EmailConfirmationsController do
  describe 'create' do
    let(:user) { FactoryGirl.create(:user) }
    subject { post :create }

    it 'send confirmation email and redirect to profile page' do
      sign_in user
      expect(user).to receive(:send_email_confirmation)
      subject
      expect(response).to redirect_to profile_path
    end
  end
end
