require 'rails_helper'

RSpec.describe "/elections", type: :request do
  let(:user) { User.create!(email: "test@example.com", password: "password", full_name: "Test User", address: "123 Test St") }
  let(:valid_attributes) do
    { title: "Test Election", point_scale: 10, vacancies: 1, opened_at: 1.day.ago, closed_at: 1.day.from_now }
  end

  describe "GET /index" do
    it "renders a successful response" do
      Election.create! valid_attributes
      get elections_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      election = Election.create! valid_attributes
      get election_url(election)
      expect(response).to be_successful
    end
  end

  describe "POST /elections/:election_id/ballots" do
    let(:election) { Election.create! valid_attributes }
    let(:nominee) { User.create!(email: "nominee@example.com", password: "password", full_name: "Nominee", address: "456 Nominee St") }
    let!(:nomination) { Nomination.create!(election: election, nominee: nominee, nominated_by: user) }

    context "when signed in" do
      before do
        user.save_as_confirmed!
        sign_in user
      end

      it "creates votes for the nominations" do
        post election_ballots_url(election), params: {
          ballot: {
            nomination_id_scores: {
              nomination.id.to_s => "5"
            }
          }
        }

        expect(response).to be_successful
        expect(Vote.count).to eq(1)

        vote = Vote.last
        expect(vote.score).to eq(5)
        expect(vote.voter).to eq(user)
        expect(vote.votable).to eq(nomination)
      end
    end
  end
end
