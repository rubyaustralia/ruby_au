require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# Require engines
require_relative "../sites/melbourne/lib/melbourne"

module RubyAu
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    config.eager_load_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.assets false
      g.helpers false
    end

    config.generators.javascript_engine = :js

    config.time_zone = "Australia/Melbourne"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_support.to_time_preserves_timezone = :zone

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.active_job.queue_adapter = :solid_queue

    # Disable the asset pipeline
    # config.assets.enabled = false

    config.active_support.encoder_max_depth = 1000
  end
end
