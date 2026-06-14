class InvitationsController < ApplicationController
  expose(:user) { User.new user_params }
  expose(:imported_member) { ImportedMember.find_by token: params[:id] }

  def create
    return render :new unless user.valid?

    confirm_membership_invitation

    redirect_to posts_path, notice: "Your membership to Ruby Australia has been confirmed."
  end

  def unsubscribe
    imported_member.update unsubscribed_at: Time.current

    redirect_to root_path, notice: "You have been unsubscribed from membership invitations."
  end

  private

  def user_params
    hash = params.fetch(:user, {}).permit(
      :full_name, :email, :password, :password_confirmation, :address, :visible
    )

    hash[:full_name] ||= imported_member.full_name
    hash[:email]     ||= imported_member.email

    hash
  end

  def confirm_membership_invitation
    user.save_as_confirmed!
    sign_in user

    track_invitation_acceptance
  end

  def track_invitation_acceptance
    PostHog.identify(
      distinct_id: user.posthog_distinct_id,
      properties: user.posthog_properties
    )
    PostHog.capture(
      distinct_id: user.posthog_distinct_id,
      event: 'invitation_accepted'
    )
  end
end
