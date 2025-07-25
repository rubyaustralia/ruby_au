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
               image: nil,
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
end
