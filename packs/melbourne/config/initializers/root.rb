# frozen_string_literal: true

module Melbourne
  def self.root
    @root ||= Rails.root.join("packs/melbourne")
  end

  module Routes
    DEFAULT_URL_OPTIONS = { host: "localhost", port: ENV.fetch("PORT", 3000) }
                          .merge(Rails.application.routes.default_url_options)
                          .merge(subdomain: "melbourne")
                          .freeze

    def self.url_helpers = Rails.application.routes.url_helpers
  end
end
