require "rails_helper"

RSpec.describe Melbourne::EventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "show" do
    let(:event) { Melbourne::Event.all.first }

    before do
      allow(Melbourne::Event).to \
        receive(:find_by_slug).and_return(event)
    end

    it "displays the home page" do
      get melbourne.event_path("test-name-of-event")
      expect(Melbourne::Event).to \
        have_received(:find_by_slug).with("test-name-of-event")
      expect(response.status).to eq(200)
      expect(response.body).to include(event.name)
    end
  end
end
