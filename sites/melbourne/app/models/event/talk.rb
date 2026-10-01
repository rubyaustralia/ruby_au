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

      YOUTUBE_HOSTS = %w[youtube.com m.youtube.com music.youtube.com youtube-nocookie.com].freeze
      YOUTUBE_PATH_PREFIXES = %w[embed shorts live v].freeze
      YOUTUBE_ID_FORMAT = /\A[\w-]+\z/

      # Extract the video ID from a YouTube URL to be used in embedding the video in an iframe.
      # Supports youtu.be share links, watch?v= links, and /embed/, /shorts/, /live/ and /v/ paths
      def youtube_video_id
        return if video_url.blank? || %w[TODO unknown].include?(video_url)

        uri = URI.parse(video_url.strip)
        id = extract_youtube_id(uri)
        id if id&.match?(YOUTUBE_ID_FORMAT)
      rescue URI::InvalidURIError
        nil
      end

      private

      def extract_youtube_id(uri)
        host = uri.host&.downcase&.delete_prefix("www.")
        segments = uri.path.to_s.split("/").compact_blank

        if host == "youtu.be"
          segments.first
        elsif YOUTUBE_HOSTS.include?(host)
          Rack::Utils.parse_query(uri.query)["v"].presence ||
            (segments[1] if YOUTUBE_PATH_PREFIXES.include?(segments.first))
        end
      end
    end
  end
end
