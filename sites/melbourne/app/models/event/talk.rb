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

      def youtube_video_id
        return if video_url.blank? || %w[TODO unknown].include?(video_url)

        # Get the 'v' url param of a youtube video url (which is like a youtube vid id) to
        # be used in embedding the youtube video in an iframe
        uri = URI.parse(video_url)
        query_params = Rack::Utils.parse_query(uri.query)
        query_params["v"]
      end
    end
  end
end
