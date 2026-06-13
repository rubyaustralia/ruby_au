# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      if resource.persisted?
        PostHog.identify(
          distinct_id: resource.posthog_distinct_id,
          properties: resource.posthog_properties
        )
        PostHog.capture(
          distinct_id: resource.posthog_distinct_id,
          event: 'user_logged_in',
          properties: { login_method: 'password' }
        )
      end
    end
  end
end
