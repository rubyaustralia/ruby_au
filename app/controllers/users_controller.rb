class UsersController < ApplicationController

  before_action :authenticate!, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      warden.set_user(@user)
      flash[:notice] = 'Thanks for registering as a member!'
      redirect_to user_path(@user)
    else
      render :new
    end
  end

  def show
    @user = User.visible_for_user(current_user).find(params[:id])
  end

  private

  def user_params
    params.require(:user).permit(
      :email,
      :full_name,
      :preferred_name,
      :mailing_list,
      :visible,
      :password
    )
  end
end
