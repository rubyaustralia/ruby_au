Rails.application.config.middleware.insert_before(ActionDispatch::Static, Rack::Static, {
  urls: %w[/vite-dev /vite-production],
  header_rules: [
    [:all, {'Cache-Control' => 'public, max-age=31536000'}],
    [%w(css js), {'Content-Type' => 'text/css; charset=utf-8'}],
    [%w(js), {'Content-Type' => 'text/javascript; charset=utf-8'}]
  ]
})
