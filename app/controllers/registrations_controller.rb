# frozen_string_literal: true

class RegistrationsController < Devise::RegistrationsController
  # rubocop:disable Rails/LexicallyScopedActionFilter
  before_action :confirm_human, only: [:create]
  # rubocop:enable Rails/LexicallyScopedActionFilter

  private

  def confirm_human
    return unless params[:human_verification].downcase['ruby'].nil?

    build_resource(sign_up_params)

    flash[:alert] = "Something wasn't quite right."
    render :new
  end
end
