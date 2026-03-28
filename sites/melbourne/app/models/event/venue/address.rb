module Melbourne
  class Event
    class Venue
      class Address
        include ActiveModel::Model
        include ActiveModel::Attributes

        attribute :street
        attribute :locality
        attribute :postal_code
        attribute :region
        attribute :country

        validates :street, presence: true
        validates :locality, presence: true
        validates :postal_code, presence: true
        validates :region, presence: true
        validates :country, presence: true
      end
    end
  end
end
