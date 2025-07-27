# frozen_string_literal: true

module Melbourne
  module Data
    class DomainModelProcessor
      def initialize(path:)
        @json_contents = JSON.parse(File.read(path))
      end

      def process # rubocop:disable Metrics/MethodLength, Metrics/AbcSize:
        json_contents.map do |event|
          date = Date.parse(event["date"]).end_of_month.prev_occurring(:thursday)
          {
            uuid: SecureRandom.uuid,
            date: date.to_s,
            name: event["name"],
            description: event["description"],
            slug: event["slug"],
            type: "meetup",
            venue: {
              name: "BOYD Community Hub",
              google_maps_url: "https://maps.app.goo.gl/Tifehaitwnf2fJSq5",
              address: {
                street: "207 City Rd",
                locality: "Southbank",
                postal_code: "3006",
                region: "VIC",
                country: "AU",
              }
            },
            talks: event["talks"].map do |talk|
              {
                id: SecureRandom.uuid,
                title: talk["title"],
                description: talk["description"],
                video_url: "TODO",
                speakers: talk["speakers"].map do |speaker|
                  {
                    name: speaker["name"],
                    contact_details: {
                      github_username: speaker.dig("contact_details", "github_username"),
                      x_handle: speaker.dig("contact_details", "x_handle"),
                      linkedin_handle: speaker.dig("contact_details", "linkedin_handle"),
                      bluesky_handle: speaker.dig("contact_details", "bluesky_handle"),
                      mastodon_handle: speaker.dig("contact_details", "mastodon_handle"),
                      website: speaker.dig("contact_details", "website"),
                    }
                  }
                end
              }
            end
          }.deep_stringify_keys
        end
      end

      private

      attr_reader :json_contents
    end
  end
end
