class PasswordsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params.dig(:change_password, :email))

    if @user
      @user.regenerate_token
      PasswordMailer.change_password(@user).deliver
    end
  end

  def edit
    warden.authenticate(:token)
    @user = warden.user

    if @user.nil?
      flash[:notice] = 'The link to reset your password has expired.'
      redirect_to root_path
    end
  end

  def update
    @user = current_user

    user_params = params.require(:change_password).permit(:password)

    if @user.update(user_params)
      flash[:notice] = 'Your password has been updated.'
      redirect_to profile_path
    else
      flash.now[:notice] = 'We were not able to update your password.'
      render :edit
    end
  end
end
