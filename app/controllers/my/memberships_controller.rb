class My::MembershipsController < My::ApplicationController
  def destroy
    membership.update left_at: current_time
    current_user.update deactivated_at: current_time

    sign_out

    redirect_to root_path, notice: "Your membership to Ruby Australia has ceased."
  end

  private

  def current_time
    @current_time ||= Time.current
  end

  def membership
    current_user.memberships.current.first
  end
end
