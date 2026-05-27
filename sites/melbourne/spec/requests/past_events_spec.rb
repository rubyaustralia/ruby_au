require "rails_helper"

RSpec.describe Melbourne::PastEventsController, type: :request do
  before do
    host! "melbourne.example.com"
  end

  describe "index" do
    let(:events) do
      [
        Melbourne::Event.new(name: "test event-1", date: Time.zone.today - 2, slug: "test-1 for controller", description: "past controller test-1"),
        Melbourne::Event.new(name: "test event-1", date: Time.zone.today - 4, slug: "test-1 for controller", description: "past controller test-2")
      ]
    end

    before do
      allow(Melbourne::Event).to receive(:past).and_return(events)
    end

    it "displays the past events" do
      get melbourne_past_events_path
      expect(response.status).to eq(200)
    end

    it "renders the index view" do
      get melbourne_past_events_path
      events.each do |event|
        expect(response.body).to include(event.description)
      end
    end
  end
end
