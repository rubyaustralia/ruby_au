module MeetingsHelper
  def rsvp_for(event)
    Rsvp.find_or_create_by(
      membership: current_user.memberships.current.first,
      rsvp_event: event
    )
  end
end
