class RsvpsController < ApplicationController
  expose(:rsvp) { Rsvp.find_by token: params[:id] }

  def update
    rsvp.update rsvp_params.merge(proxy_assigned_at: Time.current)

    redirect_to rsvp_path(rsvp.token), notice: "Thank you, your proxy representative has been recorded."
  end

  def destroy
    rsvp.update proxy_name: nil, proxy_signature: nil, proxy_assigned_at: nil

    redirect_to rsvp_path(rsvp.token), notice: "You no longer have anyone assigned as your proxy representative."
  end

  def confirm
    rsvp.update status: 'yes'

    PostHog.capture(
      distinct_id: rsvp.membership.user.posthog_distinct_id,
      event: 'rsvp_confirmed',
      properties: { event_title: rsvp.rsvp_event.title }
    )

    redirect_to rsvp_path(rsvp.token), notice: "Thanks for confirming your attendance to #{rsvp.rsvp_event.title}."
  end

  def decline
    rsvp.update status: 'no'

    PostHog.capture(
      distinct_id: rsvp.membership.user.posthog_distinct_id,
      event: 'rsvp_declined',
      properties: { event_title: rsvp.rsvp_event.title }
    )

    redirect_to rsvp_path(rsvp.token), notice: "We're sorry you can't make it to #{rsvp.rsvp_event.title}, but thanks for letting us know."
  end

  private

  def rsvp_params
    params.fetch(:rsvp, {}).permit(:proxy_name, :proxy_signature)
  end
end
