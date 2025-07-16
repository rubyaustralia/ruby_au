module Melbourne
  class Event
    class Speaker
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, default: "unknown"
      attribute :contact_details, default: {}

      def schema
        Schema.new(self)
      end
    end
  end
end
