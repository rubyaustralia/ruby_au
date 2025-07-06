module Melbourne
  class Event
    class Speaker
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, default: "unknown"
      attribute :contact_details, default: {}
    end
  end
end
