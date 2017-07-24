class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :new

  def new
    flash.now[:notice] = warden.message if warden.message.present?
  end

  def create
    warden.authenticate!(:password)
    redirect_to profile_path, notice: "Logged in!"
  end

  def destroy
    warden.logout
    redirect_to root_url, notice: "Logged out!"
  end
end
