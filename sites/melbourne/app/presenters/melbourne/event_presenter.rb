# frozen_string_literal: true

module Melbourne
  class EventPresenter
    attr_reader :event

    def initialize(event)
      @event = event
    end

    def name
      event.name
    end

    def formatted_day_number
      event.date.strftime("%d")
    end

    def formatted_month_abbreviation
      event.date.strftime("%b")
    end

    def year_is_different_from_current_year?
      event.date.year != Date.current.year
    end

    def formatted_full_date_with_weekday
      event.date.strftime("%A, %d %B")
    end

    def year
      event.date.year
    end

    def venue_name
      event.venue.name
    end

    def is_in_the_past?
      event.date < Date.current
    end

    def description
      event.description
    end

    def talks
      event.talks
    end

    def registration_status_title
      is_in_the_past? ? 'Registration Closed' : 'Registration'
    end

    def registration_link
      event.registration_link
    end

    def past_event_message
      "This event took place on #{formatted_full_date_with_weekday}#{year_is_different_from_current_year? ? " #{year}" : ""}."
    end

    def formatted_date_with_conditional_year
      "#{formatted_full_date_with_weekday}#{year_is_different_from_current_year? ? " #{year}" : ""}"
    end
  end
end
