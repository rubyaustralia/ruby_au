class UsersController < ApplicationController
  before_action :authenticate!, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to root_path, notice: 'Please confirm your account via the email we have just sent you.'
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
