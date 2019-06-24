class My::DetailsController < My::ApplicationController
  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      flash[:notice] = 'Your details have been updated.'
      redirect_to my_details_path
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :full_name, :address, :visible)
  end
end
