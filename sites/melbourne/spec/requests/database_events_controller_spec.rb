require "rails_helper"

RSpec.describe Melbourne::DatabaseEventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "show" do
    let(:event) { FactoryBot.create(:database_event, :meetup, :melbourne) }

    before do
      allow(DatabaseEvent).to \
        receive(:find_by_slug).and_return(event)
    end

    it "displays the event page" do
      get melbourne_database_event_path("test-name-of-event")
      expect(DatabaseEvent).to \
        have_received(:find_by_slug).with("test-name-of-event")
      expect(response.status).to eq(200)
      expect(response.body).to include(event.name)
    end
  end
end
