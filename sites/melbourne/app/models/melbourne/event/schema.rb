# frozen_string_literal: true

# https://developers.google.com/search/docs/appearance/structured-data/event
module Melbourne
  class Event
    class Schema
      TYPE = "Event".freeze

      def initialize(event)
        @event = event
      end

      def to_h
        {
          "@context" => "https://schema.org",
          "@type" => TYPE,
          name: event.name,
          start_date:,
          end_date:,
          event_status: "https://schema.org/EventScheduled",
          location: event.venue.schema.to_h,
          description: event.summary,
          performers: event.talks.flat_map(&:speakers).flat_map { it.schema.to_h}
        }
      end

      private

      attr_reader :event

      def event_url = ::Melbourne::Engine.routes.url_helpers.event_url(event)

      # Start date in ISO8601 format. The date should include the time and the timezone.
      # As of 2025-07-17 the time zone is set up to Australia/Melbourne in config/application.rb:49.
      # This might create problems in the future with meetups in other locations.
      # https://developers.google.com/search/docs/appearance/structured-data/event#date-time-best-guidelines
      def start_date = Time.new(event.date.year, event.date.month, event.date.day, 18).iso8601

      # Start date in ISO8601 format. The date should include the time and the timezone.
      # As of 2025-07-17 the time zone is set up to Australia/Melbourne in config/application.rb:49.
      # This might create problems in the future with meetups in other locations.
      # https://developers.google.com/search/docs/appearance/structured-data/event#date-time-best-guidelines
      def end_date = Time.new(event.date.year, event.date.month, event.date.day, 20, 30).iso8601
    end
  end
end
