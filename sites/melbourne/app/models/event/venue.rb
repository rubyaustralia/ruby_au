module Melbourne
  class Event
    class Venue
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name
      attribute :google_maps_url
      attribute :address, default: {}

      validates :name, presence: true
      validates :google_maps_url, presence: true
      validates :address, presence: true

      def schema
        Schema.new(self).to_h
      end
    end
  end
end
