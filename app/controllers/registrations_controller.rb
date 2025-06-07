# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :confirm_human, only: [:create]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  private

  def confirm_human
    return if params[:human_verification]&.downcase&.include?('ruby')

    build_resource(sign_up_params)

    flash[:alert] = "Something wasn't quite right."
    render :new
  end
end
