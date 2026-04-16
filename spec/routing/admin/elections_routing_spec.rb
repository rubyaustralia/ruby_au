require "rails_helper"

RSpec.describe Admin::ElectionsController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/admin/elections").to route_to("admin/elections#index")
    end

    it "routes to #new" do
      expect(get: "/admin/elections/new").to route_to("admin/elections#new")
    end

    it "routes to #show" do
      expect(get: "/admin/elections/1").to route_to("admin/elections#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/admin/elections/1/edit").to route_to("admin/elections#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/admin/elections").to route_to("admin/elections#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/admin/elections/1").to route_to("admin/elections#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/admin/elections/1").to route_to("admin/elections#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/admin/elections/1").to route_to("admin/elections#destroy", id: "1")
    end
  end
end
