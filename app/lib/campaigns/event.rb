# frozen_string_literal: true

class Campaigns::Event
  TZID = 'UTC'

  def self.call(rsvp_event)
    new(rsvp_event).call
  end

  def initialize(rsvp_event)
    @rsvp_event = rsvp_event
  end

  def call
    add_event
    to_ical
  end

  private

  attr_reader :rsvp_event

  delegate :to_ical, to: :calendar

  def add_alarm(event)
    event.alarm do |alarm|
      alarm.summary = "#{title} Reminder"
      alarm.trigger = '-P0DT1H0M0S' # 1 hour before
    end
  end

  def add_event
    calendar.event do |event|
      event.dtstart = datetime(rsvp_event.happens_at)
      event.dtend = datetime(rsvp_event.happens_at + 90.minutes)
      event.summary = title
      event.description = rsvp_event.link

      add_alarm(event)
    end
  end

  def calendar
    @calendar ||= Icalendar::Calendar.new.tap do |cal|
      cal.timezone do |time|
        time.tzid = TZID
      end
    end
  end

  def datetime(time)
    Icalendar::Values::DateTime.new(time, tzid: TZID)
  end

  def title
    "Ruby Australia #{rsvp_event.title}"
  end
end
