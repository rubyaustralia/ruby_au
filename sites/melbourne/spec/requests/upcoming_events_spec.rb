require 'rails_helper'

RSpec.describe Melbourne::UpcomingEventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "index" do
    let(:events) do
      [
        Melbourne::Event.new(name: "test event-1", date: Time.zone.today, slug: "test-1 for controller"),
        Melbourne::Event.new(name: "test event-2", date: Time.zone.today + 2, slug: "test-2 for controller")
      ]
    end

    before do
      allow(Melbourne::Event).to receive(:upcoming).and_return(events)
    end

    it "displays the upcoming events" do
      get melbourne_upcoming_events_path
      expect(response.status).to eq(200)
    end

    it "renders the index view" do
      get melbourne_upcoming_events_path
      events.each do |event|
        expect(response.body).to include(event.name)
      end
    end
  end
end
