require "rails_helper"

RSpec.describe UsersController, type: :controller do
  describe 'GET #show' do
    context "when profile is current users" do
      it "responds with 200 success" do
        user = create(:user)
        profile = create(:profile, user: user, visible: false)
        sign_in_as(user)

        get :show, params: { id: user }

        expect(response).to have_http_status(:success)
      end
    end

    context "when profile is visible" do
      it "responds with 200 success" do
        user = create(:user)
        profile = create(:profile, :visible, user: user)
        sign_in_as(user)

        get :show, params: { id: profile.user }

        expect(response).to have_http_status(:success)
      end
    end

    context "when profile is not visible" do
      it "responds with 404 not found" do
        user = create(:user)
        profile = create(:profile)
        sign_in_as(user)

        expect do
          get :show, params: { id: profile.user }
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
