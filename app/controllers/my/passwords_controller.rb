class My::PasswordsController < My::ApplicationController
  def update
    @user = current_user

    if @user.update_with_password(user_params)
      flash[:notice] = 'Your password has been updated. You will need to sign in again to continue.'
      redirect_to new_user_session_path
    else
      @user.clean_up_passwords
      render 'my/details/edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :password, :password_confirmation, :current_password
    )
  end
end
