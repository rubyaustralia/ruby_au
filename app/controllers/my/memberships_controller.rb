class My::MembershipsController < My::ApplicationController
  def destroy
    PostHog.capture(
      distinct_id: current_user.posthog_distinct_id,
      event: 'membership_cancelled'
    )

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
