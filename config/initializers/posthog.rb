# frozen_string_literal: true

PostHog.init do |config|
  config.api_key = ENV.fetch('POSTHOG_PROJECT_TOKEN', nil)
  config.host = ENV.fetch('POSTHOG_HOST', nil)
  config.on_error = proc { |_status, msg| Rails.logger.error("PostHog error: #{msg}") }
  config.test_mode = true if Rails.env.test?
end

PostHog::Rails.configure do |config|
  config.auto_capture_exceptions = true
  config.report_rescued_exceptions = true
  config.auto_instrument_active_job = true
  config.capture_user_context = true
  config.current_user_method = :current_user
  config.user_id_method = :posthog_distinct_id
end
