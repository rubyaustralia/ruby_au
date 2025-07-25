# frozen_string_literal: true

module Melbourne
  class Event
    private_constant :OpenGraphMetadata
    class OpenGraphMetadata
      def initialize(event)
        @event = event
      end

      def to_meta_tags # rubocop:disable Metrics/MethodLength
        {
          title: "#{event.date} - #{event.name}",
          description: event.description,
          keywords: "Events, Ruby, Rails, Melbourne",
          og: {
            title: :title,
            description: :description,
            image: nil,
            url: event_url
          },
          twitter: {
            card: "summary",
            site: "@rubyau",
            title: :title,
            description: :description,
          }
        }
      end

      private

      attr_reader :event

      def event_url = ::Melbourne::Engine.routes.url_helpers.event_url(event)
    end
  end
end
