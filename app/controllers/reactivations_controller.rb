class ReactivationsController < ApplicationController
  expose(:user) do
    params[:user].present? ? Email.find_by(email: user_params[:email])&.user : User.new
  end

  def create
    return invalid_reactivation unless reactivate?

    reactivate_membership

    redirect_to root_path, notice: "Your membership to Ruby Australia has been reactivated."
  end

  private

  def reactivate?
    user.deactivated? && user.valid_password?(user_params[:password])
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end

  def invalid_reactivation
    flash[:notice] = "The provided details are not valid."
    render :new
  end

  def reactivate_membership
    user.update deactivated_at: nil
    user.memberships.create joined_at: Time.current
    sign_in user

    track_reactivation
  end

  def track_reactivation
    PostHog.identify(
      distinct_id: user.posthog_distinct_id,
      properties: user.posthog_properties
    )
    PostHog.capture(
      distinct_id: user.posthog_distinct_id,
      event: 'membership_reactivated'
    )
  end
end
