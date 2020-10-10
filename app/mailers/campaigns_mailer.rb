# frozen_string_literal: true

class CampaignsMailer < ApplicationMailer
  helper :application
  helper :campaigns

  def campaign_email(campaign, membership)
    @membership = membership
    @campaign = campaign

    prepare_event_variables campaign

    if campaign.rsvp_event.present?
      attachments['event.ics'] = calendar(campaign.rsvp_event)
    end

    mail(
      to: @membership.user.email,
      subject: campaign.subject
    )
  end

  private

  def calendar(rsvp_event)
    calendar = Icalendar::Calendar.new

    calendar.event do |event|
      event.dtstart = rsvp_event.happens_at
      event.dtend   = rsvp_event.happens_at + 90.minutes
      event.summary = rsvp_event.title

      event.alarm do |alarm|
        alarm.summary = "#{rsvp_event.title} Reminder"
        alarm.trigger = "-P0DT1H0M0S" # 1 hour before
      end
    end

    calendar.to_ical
  end

  def prepare_event_variables(campaign)
    return if campaign.rsvp_event.blank?

    @event = campaign.rsvp_event
    @rsvp = Rsvp.find_or_create_by(
      rsvp_event: @event,
      membership: @membership
    )
  end
end
