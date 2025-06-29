module Melbourne
  class Event
    class Speaker
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :name, default: "unknown"
      attribute :github_username, default: "unknown"
    end
  end
end
