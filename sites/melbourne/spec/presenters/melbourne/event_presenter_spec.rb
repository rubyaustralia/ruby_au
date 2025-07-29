# frozen_string_literal: true

require "rails_helper"

RSpec.describe Melbourne::EventPresenter do
  subject(:presenter) { described_class.new(event) }

  let(:venue) do
    Melbourne::Event::Venue.new(
      name: "Test Venue",
      google_maps_url: "https://maps.google.com/test",
      address: { street: "123 Test St", city: "Melbourne" }
    )
  end

  let(:talks) do
    [
      Melbourne::Event::Talk.new(
        uuid: "talk-1",
        title: "First Talk",
        description: "A great talk about Ruby",
        video_url: "https://example.com/video1",
        speakers: []
      ),
      Melbourne::Event::Talk.new(
        uuid: "talk-2",
        title: "Second Talk",
        description: "Another great talk about Rails",
        video_url: "https://example.com/video2",
        speakers: []
      )
    ]
  end

  let(:event_date) { Date.new(2025, 3, 15) }
  let(:event) do
    Melbourne::Event.new(
      uuid: "event-1",
      name: "Ruby Melbourne Meetup",
      date: event_date,
      venue: venue,
      description: "An awesome Ruby meetup event",
      talks: talks,
      slug: "ruby-melbourne-meetup",
      type: "meetup",
      registration_link: "https://example.com/register"
    )
  end

  describe "#initialize" do
    it "sets the event" do
      expect(presenter.event).to eq(event)
    end
  end

  describe "#name" do
    it "returns the event name" do
      expect(presenter.name).to eq("Ruby Melbourne Meetup")
    end
  end

  describe "#formatted_day_number" do
    it "returns the day number formatted as a string" do
      expect(presenter.formatted_day_number).to eq("15")
    end
  end

  describe "#formatted_month_abbreviation" do
    it "returns the month abbreviation" do
      expect(presenter.formatted_month_abbreviation).to eq("Mar")
    end
  end

  describe "#year_is_different_from_current_year?" do
    context "when event year is different from current year" do
      let(:event_date) { Date.new(2026, 3, 15) }

      it "returns true" do
        travel_to Date.new(2025, 1, 1) do
          expect(presenter.year_is_different_from_current_year?).to be(true)
        end
      end
    end

    context "when event year is the same as current year" do
      let(:event_date) { Date.new(2025, 3, 15) }

      it "returns false" do
        travel_to Date.new(2025, 1, 1) do
          expect(presenter.year_is_different_from_current_year?).to be(false)
        end
      end
    end
  end

  describe "#formatted_full_date_with_weekday" do
    it "returns the full date with weekday" do
      expect(presenter.formatted_full_date_with_weekday).to eq("Saturday, 15 March")
    end
  end

  describe "#year" do
    it "returns the event year" do
      expect(presenter.year).to eq(2025)
    end
  end

  describe "#venue_name" do
    it "returns the venue name" do
      expect(presenter.venue_name).to eq("Test Venue")
    end
  end

  describe "#in_the_past?" do
    context "when event date is in the past" do
      let(:event_date) { Date.new(2025, 1, 15) }

      it "returns true" do
        travel_to Date.new(2025, 3, 1) do
          expect(presenter.in_the_past?).to be(true)
        end
      end
    end

    context "when event date is today" do
      let(:event_date) { Date.new(2025, 3, 1) }

      it "returns false" do
        travel_to Date.new(2025, 3, 1) do
          expect(presenter.in_the_past?).to be(false)
        end
      end
    end

    context "when event date is in the future" do
      let(:event_date) { Date.new(2025, 4, 15) }

      it "returns false" do
        travel_to Date.new(2025, 3, 1) do
          expect(presenter.in_the_past?).to be(false)
        end
      end
    end
  end

  describe "#description" do
    it "returns the event description" do
      expect(presenter.description).to eq("An awesome Ruby meetup event")
    end
  end

  describe "#talks" do
    it "returns the event talks" do
      expect(presenter.talks).to eq(talks)
    end
  end

  describe "#registration_status_title" do
    context "when event is in the past" do
      let(:event_date) { Date.new(2025, 1, 15) }

      it "returns Registration Closed" do
        travel_to Date.new(2025, 3, 1) do
          expect(presenter.registration_status_title).to eq("Registration Closed")
        end
      end
    end

    context "when event is not in the past" do
      let(:event_date) { Date.new(2025, 4, 15) }

      it "returns Registration" do
        travel_to Date.new(2025, 3, 1) do
          expect(presenter.registration_status_title).to eq("Registration")
        end
      end
    end
  end

  describe "#past_event_message" do
    context "when event year is the same as current year" do
      let(:event_date) { Date.new(2025, 3, 15) }

      it "returns message without year" do
        travel_to Date.new(2025, 4, 1) do
          expect(presenter.past_event_message).to eq("This event took place on Saturday, 15 March.")
        end
      end
    end

    context "when event year is different from current year" do
      let(:event_date) { Date.new(2024, 3, 15) }

      it "returns message with year" do
        travel_to Date.new(2025, 4, 1) do
          expect(presenter.past_event_message).to eq("This event took place on Friday, 15 March 2024.")
        end
      end
    end
  end

  describe "#formatted_date_with_conditional_year" do
    context "when event year is the same as current year" do
      let(:event_date) { Date.new(2025, 3, 15) }

      it "returns formatted date without year" do
        travel_to Date.new(2025, 4, 1) do
          expect(presenter.formatted_date_with_conditional_year).to eq("Saturday, 15 March")
        end
      end
    end

    context "when event year is different from current year" do
      let(:event_date) { Date.new(2024, 3, 15) }

      it "returns formatted date with year" do
        travel_to Date.new(2025, 4, 1) do
          expect(presenter.formatted_date_with_conditional_year).to eq("Friday, 15 March 2024")
        end
      end
    end
  end

  describe "#formatted_date_for_card" do
    context "when event year is the same as current year" do
      let(:event_date) { Date.new(2025, 3, 15) }

      it "returns formatted date without year" do
        travel_to Date.new(2025, 4, 1) do
          expect(presenter.formatted_date_for_card).to eq("15 March")
        end
      end
    end

    context "when event year is different from current year" do
      let(:event_date) { Date.new(2024, 3, 15) }

      it "returns formatted date with year" do
        travel_to Date.new(2025, 4, 1) do
          expect(presenter.formatted_date_for_card).to eq("15 March 2024")
        end
      end
    end
  end

  describe "#container_base_classes" do
    it "returns the base CSS classes for the event container" do
      expected_classes = "rounded cursor-pointer flex flex-col gap-1 border-b border-b-gray-200 px-4 pb-4 pt-3 transition-colors bg-white text-gray-500 **:data-title:text-black **:data-ascii-image:text-gray-300 hover:bg-blue-700 inset-ring-4 inset-ring-white"
      expect(presenter.container_base_classes).to eq(expected_classes)
    end
  end

  describe "#container_hover_classes" do
    it "returns the hover CSS classes for the event container" do
      expected_classes = "hover:bg-[#0D37F2] hover:border-b-transparent hover:text-white hover:**:data-title:text-white hover:**:data-ascii-image:text-[#6A86FF] hover:inset-ring-transparent"
      expect(presenter.container_hover_classes).to eq(expected_classes)
    end
  end

  describe "#dom_id" do
    it "returns the DOM ID for the event" do
      expect(presenter.dom_id).to eq("event_event-1")
    end
  end
end
