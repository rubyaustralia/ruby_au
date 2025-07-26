# frozen_string_literal: true

# https://developers.google.com/search/docs/appearance/structured-data/event#structured-data-type-definitions
# https://schema.org/Person
module Melbourne
  class Event
    class Speaker
      class Schema
        TYPE = "Person"

        def initialize(speaker)
          @speaker = speaker
        end

        def to_h
          {
            "@type" => TYPE,
            name: speaker.name,
          }
        end

        private

        attr_reader :speaker
      end
    end
  end
end
