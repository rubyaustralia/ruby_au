# Set URLs to expire after a longer period in production
Rails.application.config.active_storage.service_urls_expire_in = 1.week

# Configure the host for ActiveStorage URLs
Rails.application.config.active_storage.routes_prefix = '/rails/active_storage'

# Set the host for Active Storage URLs (only in production)
if Rails.env.production?
  Rails.application.routes.default_url_options[:host] = 'ruby.org.au'
  Rails.application.routes.default_url_options[:protocol] = 'https'
elsif Rails.env.development?
  Rails.application.routes.default_url_options[:host] = 'localhost:3000'
  Rails.application.routes.default_url_options[:protocol] = 'http'
end
