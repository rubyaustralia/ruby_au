class ReactivationsController < ApplicationController
  expose(:user) do
    params[:user].present? ? Email.find_by(email: user_params[:email])&.user : User.new
  end

  def create
    if reactivate?
      user.update deactivated_at: nil
      user.memberships.create joined_at: Time.current

      sign_in user

      redirect_to root_path, notice: "Your membership to Ruby Australia has been reactivated."
    else
      flash[:notice] = "The provided details are not valid."
      render :new
    end
  end

  private

  def reactivate?
    user.deactivated? && user.valid_password?(user_params[:password])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
