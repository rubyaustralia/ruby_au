class EmailConfirmationsController < ApplicationController
  def show
    user = warden.authenticate(:token)

    if user.nil?
      flash[:notice] = 'Could not confirm your email address. Invalid token.'
    else
      user.update_attribute :email_confirmed, true
      flash[:notice] = 'You email address is confirmed'
    end

    redirect_to profile_path
  end

  def create
    authenticate!

    flash[:notice] = 'The email was sent, please check your mailbox' if current_user.send_email_confirmation

    redirect_to profile_path
  end
end
