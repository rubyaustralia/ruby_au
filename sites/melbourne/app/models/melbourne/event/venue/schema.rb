# frozen_string_literal: true

# https://developers.google.com/search/docs/appearance/structured-data/event#structured-data-type-definitions
# https://schema.org/PostalAddress
module Melbourne
  class Event
    class Venue
      class Schema
        TYPE = "Place".freeze

        def initialize(venue)
          @venue = venue
        end

        def to_h
          {
            "@type" => TYPE,
            name: venue.name,
            address: {
              "@type" => "PostalAddress",
              street_address: nil,
              address_locality: nil,
              postal_code: nil,
              address_region: nil,
              address_country: "AU"
            }
          }
        end

        private

        attr_reader :venue
      end
    end
  end
end
