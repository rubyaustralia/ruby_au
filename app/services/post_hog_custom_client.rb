require 'net/http'
require 'json'

class PostHogCustomClient
  def initialize
    @api_key = Rails.application.credentials[:POSTHOG_PROJECT_TOKEN]
    @project_id = Rails.application.credentials[:POSTHOG_UI_HOST]
    @host = Rails.application.credentials[:POSTHOG_HOST]
    validate_config!
  end

  def configured?
    @api_key.present? && @project_id.present?
  end

  def query(hogql)
    return {} unless configured?

    post("/api/projects/#{@project_id}/query/", {
           query: {
             kind: 'HogQLQuery',
             query: hogql
           }
         })
  end

  private

  def validate_config!
    Rails.logger.warn("PostHog Warning: personal_api_key is missing from credentials. Analytics will not load.") if @api_key.blank?
    return if @project_id.present?

    Rails.logger.warn("PostHog Warning: project_id is missing from credentials. Analytics will not load.")
  end

  def post(path, body)
    uri = URI.join(@host, path)
    response = execute_post(uri, body)
    JSON.parse(response.body)
  rescue StandardError => e
    Rails.logger.error("PostHog API Error: #{e.message}")
    {}
  end

  def execute_post(uri, body)
    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@api_key}"
    request['Content-Type'] = 'application/json'
    request.body = body.to_json

    Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(request)
    end
  end
end
