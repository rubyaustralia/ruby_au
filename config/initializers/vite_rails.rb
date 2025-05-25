if defined?(ViteRuby)
  Rails.application.config.vite.manifest_path = Rails.root.join('public/vite')
end