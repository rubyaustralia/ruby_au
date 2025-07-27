module Melbourne
  class Event
    class Speaker
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, default: "unknown"
      attribute :contact_details, default: {}

      validates :name, presence: true
      validates :contact_details, presence: true

      def schema
        Schema.new(self).to_h
      end
    end
  end
end
