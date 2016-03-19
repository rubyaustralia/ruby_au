require "rails_helper"

describe PagesController do
  render_views

  describe "on GET to /committee-members" do
    before { get :show, params: { id: "committee-members" } }

    it "responds with success and render template" do
      expect(response).to be_success
      expect(response).to render_template("committee-members")
    end
  end

  describe "on GET to /committee-members" do
    before { get :show, params: { id: "committee-members.html" } }

    it "responds with success and render template" do
      expect(response).to be_success
      expect(response).to render_template("committee-members.html")
    end
  end

  it "raises a routing error for an invalid page" do
    expect { get :show, params: { id: "invalid" } }
      .to raise_error(ActionController::RoutingError)
  end

  it "raises a routing error for a page in another directory" do
    expect { get :show, params: { id: "other/wrong" } }
      .to raise_error(ActionController::RoutingError)
  end
end
