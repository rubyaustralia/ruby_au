require 'rails_helper'

# rubocop:disable RSpec/MultipleMemoizedHelpers
RSpec.describe "Admin::Nominations", type: :request do
  let(:admin) { create(:user, :committee) }
  let(:election) { create(:election) }
  let(:nominee_user) { create(:user) }
  let(:nominator_user) { create(:user) }
  let(:nominee_email) { create(:email, user: nominee_user).email }
  let(:nominator_email) { create(:email, user: nominator_user).email }

  before do
    sign_in admin
  end

  describe "POST /admin/elections/:election_id/nominations" do
    context "with valid parameters" do
      it "creates a new Nomination" do
        expect do
          post admin_election_nominations_path(election), params: {
            nomination: {
              member_email_address: nominee_email,
              nominating_member_email_address: nominator_email
            }
          }
        end.to change(Nomination, :count).by(1)

        expect(response).to redirect_to(admin_election_path(election))
        expect(flash[:notice]).to eq("Nomination was successfully created.")
      end
    end

    context "with non-existent members" do
      it "does not create a nomination and renders new with unprocessable_entity" do
        expect do
          post admin_election_nominations_path(election), params: {
            nomination: {
              member_email_address: "missing@example.com",
              nominating_member_email_address: nominator_email
            }
          }
        end.not_to change(Nomination, :count)

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
# rubocop:enable RSpec/MultipleMemoizedHelpers
