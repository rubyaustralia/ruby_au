module Melbourne
  class Event
    class Venue
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name
      attribute :google_maps_url
    end
  end
end
