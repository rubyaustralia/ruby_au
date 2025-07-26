require "rails_helper"

RSpec.describe Melbourne::HomeController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "show" do
    it "displays the home page" do
      get melbourne.root_path
      expect(response.status).to eq(200)
      expect(response.body).to include("Ruby Melbourne is a")
      expect(response.body).to include("Ruby Australia Meetup")
      expect(response.body).to include("Ruby Melbourne")
    end
  end
end
