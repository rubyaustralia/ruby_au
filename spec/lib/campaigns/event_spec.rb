require 'rails_helper'

RSpec.describe Campaigns::Event do
  describe ".call" do
    let(:rsvp_event) { build_stubbed(:rsvp_event) }

    it "initializes the class and calls #call" do
      event = described_class.new(rsvp_event)
      allow(described_class).to receive(:new).and_return(event)
      allow(event).to receive(:call)

      described_class.call(rsvp_event)

      expect(described_class).to have_received(:new).with(rsvp_event)
      expect(event).to have_received(:call)
    end
  end

  describe "#call" do
    subject(:ics) { described_class.new(rsvp_event).call }

    let(:rsvp_event) { create(:rsvp_event, title: "AGM", happens_at:, link: "https://example.com") }
    let(:happens_at) { Time.find_zone(time_zone).parse("2025-01-01 11:00:00") }
    let(:time_zone) { "UTC" }

    it "returns an ICS file describing the event" do
      expect(ics).to include(
        %w[
          BEGIN:VTIMEZONE
          TZID:UTC
          END:VTIMEZONE
        ].join("\r\n")
      )
      expect(ics).to include(
        [
          "DTSTART:20250101T110000Z",
          "DTEND:20250101T123000Z",
          "DESCRIPTION:https://example.com",
          "SUMMARY:Ruby Australia AGM"
        ].join("\r\n")
      )
    end

    context "when the event is not scheduled in UTC time" do
      let(:time_zone) { "Melbourne" }

      it "returns an ICS file describing the event" do
        expect(ics).to include(
          %w[
            BEGIN:VTIMEZONE
            TZID:UTC
            END:VTIMEZONE
          ].join("\r\n")
        )
        expect(ics).to include(
          [
            "DTSTART:20250101T000000Z",
            "DTEND:20250101T013000Z",
            "DESCRIPTION:https://example.com",
            "SUMMARY:Ruby Australia AGM"
          ].join("\r\n")
        )
      end
    end
  end
end
