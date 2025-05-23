class ApplicationController < ActionController::Base
  expose(:complex_view?) { false }
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :track_ahoy_visit

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:full_name, :address, :visible, { mailing_lists: MailingList.all.collect(&:name) }]
    )
  end

  private

  def track_ahoy_visit
    ahoy.track_visit
  end

  def report_errors(object, success_message = nil)
    if object.errors.any?
      flash[:notice] = object.errors.full_messages.join('. ')
    elsif success_message
      flash[:notice] = success_message
    end
  end
end
