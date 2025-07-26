# frozen_string_literal: true

module Melbourne
  class Engine < Rails::Engine
    isolate_namespace Melbourne

    root.join("lib").tap do |lib|
      config.autoload_paths << lib.to_s
      config.eager_load_paths << lib.to_s
    end

    routes.default_url_options = { host: "localhost", port: 3000, subdomain: "melbourne" }
  end
end
