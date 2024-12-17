require "rails_helper"

RSpec.describe "Reactivations", type: :request do
  describe "POST /reactivations" do
    let(:user) { create(:user, :deactivated) }

    before do
      user
    end

    context "with valid parameters" do
      it "reactivationss the user" do
        post "/reactivations", params: { user: { email: user.email, password: user.password } }
        expect(response).to redirect_to(root_path)
        expect(user.reload.deactivated_at).to be_nil
      end

      it "signs in the user" do
        post "/reactivations", params: { user: { email: user.email, password: user.password } }
        expect(controller.current_user).to eq(user)
      end
    end

    context "with invalid parameters" do
      it "does not reactivations the user" do
        post "/reactivations", params: { user: { email: user.email, password: "wrong_password" } }
        expect(response).to render_template(:new)
        expect(user.reload.deactivated_at).not_to be_nil
      end

      it "does not create a new membership" do
        expect {
          post "/reactivations", params: { user: { email: user.email, password: "wrong_password" } }
        }.not_to change(Membership, :count)
      end

      it "does not sign in the user" do
        post "/reactivations", params: { user: { email: user.email, password: "wrong_password" } }
        expect(controller.current_user).to be_nil
      end
    end
  end
end
