# frozen_string_literal: true

class SessionsController < Devise::SessionsController
  def create
    super do |resource|
      track_login(resource) if resource.persisted?
    end
  end

  private

  def track_login(resource)
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
