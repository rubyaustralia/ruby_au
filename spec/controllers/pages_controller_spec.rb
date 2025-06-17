require "rails_helper"

describe PagesController do
  render_views

  describe "on GET to /committee-members" do
    before { get :show, params: { id: "committee-members" } }

    it "responds with success and render template" do
      expect(response).to be_successful
      expect(response).to render_template("committee-members")
    end
  end

  describe "when handling invalid page requests" do
    context "with a non-existent page" do
      it "raises a routing error" do
        expect { get :show, params: { id: "invalid" } }
          .to raise_error(ActionController::RoutingError)
      end
    end

    context "with a page in another directory" do
      it "raises a routing error" do
        expect { get :show, params: { id: "other/wrong" } }
          .to raise_error(ActionController::RoutingError)
      end
    end
  end
end
