require 'rails_helper'

RSpec.describe "UpcomingEvents", type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "GET /index" do
    it "returns http success" do
      get "/upcoming_events"
      expect(response).to have_http_status(:success)
    end
  end
end
