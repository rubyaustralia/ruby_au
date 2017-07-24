class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :signed_in?
  helper_method :current_user

  private

  def signed_in?
    warden&.authenticate && current_user
  end

  def warden
    request.env['warden']
  end

  def current_user
    warden.user
  end

  def authenticate!
    warden.authenticate!
  end
end
