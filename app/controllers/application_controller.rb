class ApplicationController < ActionController::Base
  expose(:complex_view?) { false }
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:full_name, :preferred_name])
  end

  private

  def report_errors(object, success_message = nil)
    if object.errors.any?
      flash[:notice] = object.errors.full_messages.join('. ')
    elsif success_message
      flash[:notice] = success_message
    end
  end
end
