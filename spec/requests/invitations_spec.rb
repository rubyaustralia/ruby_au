require 'rails_helper'

RSpec.describe "Invitations", type: :request do
  describe "POST /invitations/:id" do
    let(:imported_member) { create(:imported_member) }

    context "with valid user params" do
      let(:user_params) { { full_name: "Test User", email: imported_member.email, password: "password", password_confirmation: "password", address: 'dummy address' } }

      it "creates a new user and signs them in" do
        # Add stub for CreateSend API request
        stub_request(:get, %r{https://api.createsend.com/api/v3.3/subscribers/.*})
          .with(headers: { 'Content-Type' => 'application/json; charset=utf-8' })
          .to_return(
            status: 200,
            body: { State: "Active" }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

        post "/invitations/#{imported_member.token}", params: { user: user_params }


        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq("Your membership to Ruby Australia has been confirmed.")
        user = User.last
        expect(user.full_name).to eq("Test User")
        expect(user.emails.count).to be(1)
        expect(user.email).to eq(imported_member.email)
        expect(user.confirmed_at).to_not be_nil
        expect(controller.current_user).to eq(user)
      end
    end

    context "with invalid user params" do
       let(:user_params) { { full_name: "", email: imported_member.email, password: "password", password_confirmation: "wrong_password" } }

      it "renders the new template" do
        post "/invitations/#{imported_member.token}", params: { user: user_params }
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /invitations/:id/unsubscribe" do
    let(:imported_member) { create(:imported_member) }

    it "updates the imported member's unsubscribed_at and redirects" do
      get "/invitations/#{imported_member.token}/unsubscribe"
      expect(response).to redirect_to(root_path)
      expect(flash[:notice]).to eq("You have been unsubscribed from membership invitations.")
      expect(imported_member.reload.unsubscribed_at).to_not be_nil
    end
  end
end
