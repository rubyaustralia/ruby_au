require 'rails_helper'

RSpec.describe Melbourne::UpcomingEventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "index" do
    let(:events) { Melbourne::Event.upcoming }

    before do
      allow(Melbourne::Event).to receive(:upcoming).and_return(events)
    end

    it "displays the upcoming events" do
      get melbourne_upcoming_events_path
      expect(response.status).to eq(200)
    end

    it "renders the index view" do
      event = events.first
      get melbourne_upcoming_events_path
      expect(response.body).to include(event.name)
    end
  end
end
