class Api::Youtube::PlaylistsController < ApplicationController
  require 'net/http'
  require 'json'

  def show
    playlist_id = params[:id]
    api_key = Rails.application.credentials.youtube_api_key

    if api_key.blank?
      render json: { error: 'YouTube API key not configured' }, status: :service_unavailable
      return
    end

    begin
      videos = fetch_playlist_videos(playlist_id, api_key)
      render json: { videos: videos }
    rescue StandardError => e
      Rails.logger.error "YouTube API Error: #{e.message}"
      render json: { error: 'Unable to fetch videos' }, status: :service_unavailable
    end
  end

  private

  def fetch_playlist_videos(playlist_id, api_key)
    uri = URI("https://www.googleapis.com/youtube/v3/playlistItems")
    params = {
      part: 'snippet',
      maxResults: 10,
      playlistId: playlist_id,
      key: api_key
    }
    uri.query = URI.encode_www_form(params)

    response = Net::HTTP.get_response(uri)

    unless response.is_a?(Net::HTTPSuccess)
      raise "HTTP Error: #{response.code} #{response.message}"
    end

    data = JSON.parse(response.body)

    data['items'].map do |item|
      snippet = item['snippet']
      thumbnails = snippet['thumbnails'] || {}

      thumbnail_url = thumbnails.dig('medium', 'url') ||
                      thumbnails.dig('high', 'url') ||
                      thumbnails.dig('default', 'url') ||
                      "https://img.youtube.com/vi/#{snippet.dig('resourceId', 'videoId')}/mqdefault.jpg"

      {
        id: snippet.dig('resourceId', 'videoId'),
        title: snippet['title'],
        description: snippet['description'] || '',
        thumbnail: thumbnail_url,
        publishedAt: snippet['publishedAt']
      }
    end
  end
end
