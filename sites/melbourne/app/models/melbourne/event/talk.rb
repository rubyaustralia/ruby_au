module Melbourne
  class Event
    class Talk
      include ActiveModel::Model
      include ActiveModel::Attributes

      attribute :uuid
      attribute :title
      attribute :description
      attribute :video_url, default: "unknown"
      attribute :speakers, default: []

      validates :uuid, presence: true
      validates :title, presence: true
      validates :description, presence: true
      validates :video_url, presence: true
      validates :speakers, presence: true
    end
  end
end
