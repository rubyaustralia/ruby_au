# frozen_string_literal: true

Rails.application.config.posthog = {
  api_key: Rails.application.credentials[:POSTHOG_PROJECT_TOKEN],
  host: Rails.application.credentials[:POSTHOG_HOST],
  on_error: proc { |_status, msg| Rails.logger.error("PostHog error: #{msg}") },
  test_mode: Rails.env.test?
}

PostHog::Rails.configure do |config|
  config.auto_capture_exceptions = true
  config.report_rescued_exceptions = true
  config.auto_instrument_active_job = true
  config.capture_user_context = true
  config.current_user_method = :current_user
  config.user_id_method = :posthog_distinct_id
end
