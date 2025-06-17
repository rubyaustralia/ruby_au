# frozen_string_literal: true

module Youtube
  class PlaylistService
    require 'net/http'
    require 'json'

    def initialize(api_key)
      @api_key = api_key
    end

    def fetch_videos(playlist_id)
      response = make_api_request(playlist_id)
      parse_videos_response(response)
    end

    private

    attr_reader :api_key

    def make_api_request(playlist_id)
      uri = build_api_uri(playlist_id)
      response = Net::HTTP.get_response(uri)

      raise "HTTP Error: #{response.code} #{response.message}" unless response.is_a?(Net::HTTPSuccess)

      response
    end

    def build_api_uri(playlist_id)
      uri = URI('https://www.googleapis.com/youtube/v3/playlistItems')
      uri.query = URI.encode_www_form(api_params(playlist_id))
      uri
    end

    def api_params(playlist_id)
      {
        part: 'snippet',
        maxResults: 10,
        playlistId: playlist_id,
        key: api_key
      }
    end

    def parse_videos_response(response)
      data = JSON.parse(response.body)
      data['items'].map { |item| build_video_data(item) }
    end

    def build_video_data(item)
      snippet = item['snippet']
      {
        id: extract_video_id(snippet),
        title: snippet['title'],
        description: snippet['description'] || '',
        thumbnail: extract_thumbnail_url(snippet),
        publishedAt: snippet['publishedAt']
      }
    end

    def extract_video_id(snippet)
      snippet.dig('resourceId', 'videoId')
    end

    def extract_thumbnail_url(snippet)
      thumbnails = snippet['thumbnails'] || {}
      video_id = extract_video_id(snippet)

      thumbnails.dig('medium', 'url') ||
        thumbnails.dig('high', 'url') ||
        thumbnails.dig('default', 'url') ||
        "https://img.youtube.com/vi/#{video_id}/mqdefault.jpg"
    end
  end
end
