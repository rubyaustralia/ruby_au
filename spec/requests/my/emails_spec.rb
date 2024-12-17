require 'rails_helper'

RSpec.describe "My::Emails", type: :request do
  let(:user) { create(:user) }

  before do
    sign_in user
  end

  describe "GET /new" do
    it "renders the new template" do
      get new_my_email_path
      expect(response).to render_template(:new)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new email and redirects to my_details_path" do
        expect {
          post my_emails_path, params: { email: { email: "test@example.com" } }
        }.to change(Email, :count).by(1)
        expect(response).to redirect_to(my_details_path)
      end
    end

    context "with invalid parameters" do
      it "re-renders the new template" do
        expect {
          post my_emails_path, params: { email: { email: "" } }
        }.not_to change(Email, :count)
        expect(response).to render_template(:new)
      end
    end
  end

  describe "PATCH /set_primary" do
    let!(:primary_email) { create(:email, user: user, primary: true) }
    let!(:new_email) { create(:email, user: user) }

    it "sets the specified email as primary and redirects to my_details_path" do
      put set_primary_my_email_path(new_email)

      expect(new_email.reload.primary).to be true
      expect(primary_email.reload.primary).to be false
      expect(response).to redirect_to(my_details_path)
    end
  end

  describe "DELETE /destroy" do
    let!(:email) { create(:email, user: user) }

    it "deletes the specified email and redirects to my_details_path" do
      expect {
        delete my_email_path(email)
      }.to change(Email, :count).by(-1)
      expect(response).to redirect_to(my_details_path)
    end
  end
end
