require "herb/rails"

ActionView::Template.register_template_handler(:herb, Herb::Rails::TemplateHandler.new)

# Optional configuration for Herb
Herb.configure do |config|
  # Default configuration settings
  # config.pretty = Rails.env.development?  # Pretty output in development
  # config.capture_generator = :instance_eval  # Default capture method
end
