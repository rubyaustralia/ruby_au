# frozen_string_literal: true

module Melbourne
  module Data
    class RawIssuesProcessor
      def initialize(path:)
        @json_contents = JSON.parse(File.read(path))
      end

      def process # rubocop:disable Metrics/MethodLength
        json_contents.map do |date, talks|
          date = Date.parse(date).end_of_month.prev_occurring(:thursday)
          {
            uuid: SecureRandom.uuid,
            date: date.to_s,
            type: "meetup",
            venue: {
              name: "BOYD Community Hub",
              google_maps_url: "https://maps.app.goo.gl/Tifehaitwnf2fJSq5"
            },
            talks: talks.map do |talk|
              {
                id: talk['id'],
                title: talk['title'],
                description: talk['description'],
                video_url: "TODO",
                speaker: {
                  name: "TODO",
                  github_username: "TODO"
                },
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
