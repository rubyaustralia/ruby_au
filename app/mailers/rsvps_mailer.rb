class RsvpsMailer < ApplicationMailer
  helper :application

  def announcement(rsvp)
    @rsvp = rsvp
    @membership = rsvp.membership
    @event = rsvp.rsvp_event

    mail(
      to: @membership.user.email,
      subject: 'Announcement: Ruby Australia AGM 2019'
    )
  end
end
