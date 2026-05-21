require "rails_helper"

RSpec.describe Melbourne::PastEventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "index" do
    let(:events) { Melbourne::Event.past }

    before do
      allow(Melbourne::Event).to receive(:past).and_return(events)
    end

    it "displays the past events" do
      get melbourne_past_events_path
      expect(response.status).to eq(200)
    end

    it "renders the index view" do
      event = events.first
      get melbourne_past_events_path
      expect(response.body).to include(event.description)
    end
  end
end
