# frozen_string_literal: true

# https://developers.google.com/search/docs/appearance/structured-data/event#structured-data-type-definitions
# https://schema.org/PostalAddress
module Melbourne
  class Event
    class Venue
      class Schema
        TYPE = "Place"

        def initialize(venue)
          @venue = venue
        end

        def to_h # rubocop:disable Metrics/MethodLength
          {
            "@type" => TYPE,
            name: venue.name,
            address: {
              "@type" => "PostalAddress",
              street_address: venue.address.street,
              address_locality: venue.address.locality,
              postal_code: venue.address.postal_code,
              address_region: venue.address.region,
              address_country: venue.address.country
            }
          }
        end

        private

        attr_reader :venue
      end
    end
  end
end
