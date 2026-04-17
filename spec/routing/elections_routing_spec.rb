require "rails_helper"

RSpec.describe ElectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/elections").to route_to("elections#index")
    end

    it "routes to #show" do
      expect(get: "/elections/1").to route_to("elections#show", id: "1")
    end

    it "routes to ballots#create" do
      expect(post: "/elections/1/ballots").to route_to("ballots#create", election_id: "1")
    end
  end
end
