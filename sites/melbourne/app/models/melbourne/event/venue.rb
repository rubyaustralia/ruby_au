module Melbourne
  class Event
    class Venue
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name
      attribute :google_maps_url
      attribute :address, default: {}

      def schema
        Schema.new(self)
      end
    end
  end
end
