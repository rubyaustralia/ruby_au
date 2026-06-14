# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  before_action :confirm_human, only: [:create]

  def create
    super do |resource|
      track_signup(resource) if resource.persisted?
    end
  end

  private

  def confirm_human
    return if params[:human_verification]&.downcase&.include?('ruby')

    build_resource(sign_up_params)

    flash[:alert] = "Something wasn't quite right."
    render :new
  end

  def track_signup(resource)
    PostHog.identify(
      distinct_id: resource.posthog_distinct_id,
      properties: resource.posthog_properties
    )
    PostHog.capture(
      distinct_id: resource.posthog_distinct_id,
      event: 'user_signed_up',
      properties: { signup_method: 'form' }
    )
  end
end
