# frozen_string_literal: true

class Api::Youtube::PlaylistsController < ApplicationController
  require 'net/http'
  require 'json'

  def show
    playlist_id = params[:id]
    api_key = Rails.application.credentials.youtube_api_key

    return render_api_error('YouTube API key not configured') if api_key.blank?

    videos = Youtube::PlaylistService.new(api_key).fetch_videos(playlist_id)
    render json: { videos: videos }
  rescue StandardError => e
    Rails.logger.error "YouTube API Error: #{e.message}"
    render_api_error('Unable to fetch videos')
  end

  private

  def render_api_error(message)
    render json: { error: message }, status: :service_unavailable
  end
end
