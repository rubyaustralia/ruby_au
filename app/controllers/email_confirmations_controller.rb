class EmailConfirmationsController < ApplicationController
  def show
    user = warden.authenticate(:token)

    if user.nil?
      flash[:notice] = 'We could not confirm your email address - the supplied token is invalid.'
    else
      user.update email_confirmed: true
      flash[:notice] = 'Your email address is now confirmed.'
    end

    redirect_to profile_path
  end

  def create
    authenticate!

    flash[:notice] = 'A confirmation email has been sent. Please check your inbox.' if current_user.send_email_confirmation

    redirect_to profile_path
  end
end
