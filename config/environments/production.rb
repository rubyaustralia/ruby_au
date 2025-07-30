require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance and memory savings (ignored by Rake tasks).
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Ensures that a master key has been made available in ENV["RAILS_MASTER_KEY"], config/master.key
  # config.require_master_key = true

  # Turn on fragment caching in view templates.
  config.action_controller.perform_caching = true

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.asset_host = "http://assets.example.com"

  # Assume all access to the app is happening through a SSL-terminating reverse proxy.
  config.assume_ssl = true

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  config.force_ssl = true

  # Log to STDOUT by default
  config.logger = ActiveSupport::Logger.new($stdout)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  # Log to STDOUT with the current request id as a default log tag.
  config.log_tags = [:request_id]

  # Change to "debug" to log everything (including potentially personally-identifiable information!)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")

  # Prevent health checks from clogging up the logs.
  config.silence_healthcheck_path = "/up"

  # Don't log any deprecations.
  config.active_support.report_deprecations = false

  # Replace the default in-process and non-durable queuing backend for Active Job.
  # config.active_job.queue_adapter = :resque

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  config.action_mailer.perform_caching = false

  # Specify outgoing SMTP server. Remember to add smtp/* credentials via rails credentials:edit.
  config.action_mailer.default_url_options = { host: 'ruby.org.au' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    user_name: ENV['SENDGRID_USERNAME'],
    password: ENV['SENDGRID_PASSWORD'],
    domain: 'ruby.org.au',
    address: 'smtp.sendgrid.net',
    port: 587,
    authentication: :plain,
    enable_starttls_auto: true
  }

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false

  # Only use :id for inspections in production.
  config.active_record.attributes_for_inspect = [:id]

  # Store files locally.
  config.active_storage.service = :local

  config.active_storage.resolve_model_to_route = :rails_storage_redirect

  # Make sure Active Storage URLs match your ActionMailer settings
  config.active_storage.default_url_options = { host: 'ruby.org.au', protocol: 'https' }

  config.middleware.use Rack::Deflater
  config.public_file_server.headers = {
    'Cache-Control' => 'public, max-age=31536000',
    'Expires' => 1.year.from_now.to_formatted_s(:rfc822)
  }
  config.active_storage.resolve_model_to_route = :rails_storage_redirect

  # Make sure Active Storage URLs match your ActionMailer settings
  config.active_storage.default_url_options = { host: 'ruby.org.au', protocol: 'https' }

  # ensure Rails is correctly serving static files in production
  config.public_file_server.enabled = true

  # TLD = 2 means Rails will assume .org.au as the TLD.
  # in the url ruby.org.au: domain: "ruby",tld: ["org", "au"]
  # in the url melbourne.ruby.org.au: subdomain: "melbourne", domain: "ruby",tld: ["org", "au"]
  config.action_dispatch.tld_length = 2

  # config.assets.compile = false

  config.vite_ruby.config_path = Rails.root.join('config/vite.json')
end
