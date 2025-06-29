module Melbourne
  class Event
    class Talk
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :id
      attribute :title
      attribute :description
      attribute :video_url, default: "unknown"
      attribute :speaker
    end
  end
end
