require "rails_helper"

RSpec.describe Melbourne::Event do
  describe ".all" do
    it "returns all events, sorted by date descending" do
      events = described_class.all
      expect(events).to be_an(Array)

      first_event = events.first
      expect(first_event).to be_a(described_class)
      expect(first_event.venue).to be_a(Melbourne::Event::Venue)
      expect(first_event.talks).to be_an(Array)
      expect(first_event.talks.first).to be_a(Melbourne::Event::Talk)
      expect(first_event.talks.first.speakers.first).to be_a(Melbourne::Event::Speaker)
    end

    describe "validate YML db data" do
      it "is valid" do
        described_class.all.each do |event| # rubocop:disable Rails/FindEach
          puts "Validating event: #{event.uuid}"
          expect(event.valid?).to be(true)
          puts "Validating venue: #{event.venue.name}"
          expect(event.venue.valid?).to be(true)
          event.talks.each do |talk|
            puts "Validating talk: #{talk.uuid}"
            expect(talk.valid?).to be(true)
            talk.speakers.each do |speaker|
              puts "Validating speaker: #{speaker.name}"
              expect(speaker.valid?).to be(true)
            end
          end
        end
      end
    end
  end

  describe ".find_by_slug" do
    subject(:event) { described_class.all.first }

    it "returns the event with the matching slug" do
      found_event = described_class.find_by_slug(event.slug) # rubocop:disable Rails/DynamicFindBy
      expect(found_event.slug).to eq(event.slug)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      event = described_class.new(slug: "hello-123")
      expect(event.to_param).to eq("hello-123")
    end
  end

  describe "#schema" do
    it "returns the event schema" do # rubocop:disable RSpec/ExampleLength
      event = described_class.new(
        slug: "2025-04-24-make-vs-justfile-vs-mise-rails-8-new",
        date: Date.new(2025, 4, 24),
        name: "Name of the event",
        description: "Make vs justfile vs mise and Rails 8 new with Michael Milewski and John Sherwood.",
        venue: Melbourne::Event::Venue.new(
          name: "BOYD Community Hub",
          address: {
            street: "207 City Rd",
            locality: "Southbank",
            postal_code: '3006',
            region: "VIC",
            country: "AU",
          }
        ),
        talks: [
          Melbourne::Event::Talk.new(
            title: "Make vs justfile vs mise",
            speakers: [Melbourne::Event::Speaker.new(name: "Michael Milewski")]
          ),
          Melbourne::Event::Talk.new(
            title: "Rails 8 new",
            speakers: [Melbourne::Event::Speaker.new(name: "John Sherwood")]
          )
        ]
      )
      expect(event.schema).to \
        eq({
             "@context" => "https://schema.org",
             "@type" => "Event",
             name: "Name of the event",
             description: "Make vs justfile vs mise and Rails 8 new with Michael Milewski and John Sherwood.",
             start_date: Time.new(2025, 4, 24, 18).iso8601,
             end_date: Time.new(2025, 4, 24, 20, 30).iso8601,
             event_status: "https://schema.org/EventScheduled",
             location: {
               "@type" => "Place",
               name: "BOYD Community Hub",
               address: {
                 "@type" => "PostalAddress",
                 street_address: "207 City Rd",
                 address_locality: "Southbank",
                 postal_code: "3006",
                 address_region: "VIC",
                 address_country: "AU"
               }
             },
             performers: [
               {
                 "@type" => "Person",
                 name: "Michael Milewski"
               },
               {
                 "@type" => "Person",
                 name: "John Sherwood"
               }
             ]
           })
    end
  end

  describe "#open_graph_metadata" do
    it "returns the event open graph metadata" do
      event = described_class.new(
        name: "The event name",
        slug: "2025-04-24-make-vs-justfile-vs-mise-rails-8-new",
        date: Date.new(2025, 4, 24),
        description: "Make vs justfile vs mise and Rails 8 new with Michael Milewski and John Sherwood.",
      )
      expect(event.open_graph_metadata).to \
        eq({
             title: "2025-04-24 - The event name",
             description: "Make vs justfile vs mise and Rails 8 new with Michael Milewski and John Sherwood.",
             keywords: "Events, Ruby, Rails, Melbourne",
             og: {
               title: :title,
               description: :description,
               image: "/vite-test/assets/ruby_melbourne_og-DV58EnLN.png",
               url: "http://melbourne.localhost:3000/events/2025-04-24-make-vs-justfile-vs-mise-rails-8-new",
             },
             twitter: {
               card: "summary",
               site: "@rubyau",
               title: :title,
               description: :description,
             }
           })
    end
  end

  describe ".next_event" do
    it "returns the next future event" do
      allow(described_class).to \
        receive(:all).and_return(
          [
            described_class.new(date: 2.days.from_now),
            described_class.new(date: 1.day.ago),
            described_class.new(date: 1.day.from_now)
          ]
        )

      next_event = described_class.next_event
      expect(next_event).to be_a(described_class)
      expect(next_event.date).to eq(1.day.from_now.to_date)
    end

    it "returns nil when no future events exist" do
      allow(described_class).to \
        receive(:all).and_return(
          [
            described_class.new(date: 1.day.ago),
            described_class.new(date: 2.days.ago)
          ]
        )

      expect(described_class.next_event).to be_nil
    end
  end

  describe ".past" do
    it "returns all events that were scheduled to start prior to the current day" do
      expected_events = [
        described_class.new(date: 1.year.ago),
        described_class.new(date: 1.week.ago),
        described_class.new(date: 1.day.ago)
      ]

      allow(described_class).to \
        receive(:all).and_return(
          expected_events + [
            described_class.new(date: Time.zone.today),
            described_class.new(date: 1.day.from_now)
          ]
        )

      expect(described_class.past).to match_array(expected_events)
    end

    context "when it is called with an amount" do
      it "returns that many past events" do
        expected_events = [
          described_class.new(date: 1.week.ago),
          described_class.new(date: 1.day.ago)
        ]

        allow(described_class).to \
          receive(:all).and_return(
            expected_events + [
              described_class.new(date: 1.year.ago),
              described_class.new(date: Time.zone.today),
              described_class.new(date: 1.day.from_now)
            ]
          )

        expect(described_class.past(2)).to eq(expected_events)
      end
    end

    context "when there are no past events" do
      it "returns an empty array" do
        allow(described_class).to \
          receive(:all).and_return(
            [
              described_class.new(date: Time.zone.today),
              described_class.new(date: 1.day.from_now)
            ]
          )

        expect(described_class.past).to eq([])
      end
    end
  end

  describe ".last" do
    it "returns the last event by default" do
      events = [
        described_class.new(date: 3.days.ago),
        described_class.new(date: 2.days.ago),
        described_class.new(date: 1.day.ago)
      ]
      allow(described_class).to receive(:all).and_return(events)

      result = described_class.last
      expect(result).to eq([events.last])
    end

    it "returns the last n events in reverse order" do
      events = [
        described_class.new(date: 3.days.ago),
        described_class.new(date: 2.days.ago),
        described_class.new(date: 1.day.ago)
      ]
      allow(described_class).to receive(:all).and_return(events)

      result = described_class.last(2)
      expect(result).to eq([events.last, events[-2]])
    end
  end

  describe "#id" do
    it "returns the uuid" do
      event = described_class.new(uuid: "test-uuid-123")
      expect(event.id).to eq("test-uuid-123")
    end
  end

  describe "#today_or_in_the_future?" do
    it "returns true for today's events" do
      event = described_class.new(date: Date.current)
      expect(event.today_or_in_the_future?).to be(true)
    end

    it "returns true for future events" do
      event = described_class.new(date: 1.day.from_now)
      expect(event.today_or_in_the_future?).to be(true)
    end

    it "returns false for past events" do
      event = described_class.new(date: 1.day.ago)
      expect(event.today_or_in_the_future?).to be(false)
    end
  end
end
