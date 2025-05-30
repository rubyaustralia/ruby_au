# Skip Vite build during Rails asset precompile on Heroku
# since we're building assets during the Node.js buildpack phase
if ENV['DYNO'].present? && ENV['NODE_ENV'] == 'production'
  # Disable automatic Vite build during Rails asset precompile
  Rails.application.config.after_initialize do
    ViteRuby.config.skip_build = true if defined?(ViteRuby)
  end
end
