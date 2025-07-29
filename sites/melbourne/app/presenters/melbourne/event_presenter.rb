# frozen_string_literal: true

module Melbourne
  class EventPresenter
    attr_reader :event

    delegate :name,
             :description,
             :open_graph_metadata,
             :talks,
             :registration_link,
             to: :event

    def initialize(event)
      @event = event
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

    def venue_map_url
      event.venue.google_maps_url
    end

    def in_the_past?
      event.date < Date.current
    end

    def registration_status_title
      in_the_past? ? 'Registration Closed' : 'Registration'
    end

    def past_event_message
      "This event took place on #{formatted_date_with_conditional_year}."
    end

    def formatted_date_with_conditional_year
      "#{formatted_full_date_with_weekday}#{year_is_different_from_current_year? ? " #{year}" : ''}"
    end

    def formatted_date_for_card
      formatted_date = event.date.strftime("%d %B")
      year_is_different_from_current_year? ? "#{formatted_date} #{year}" : formatted_date
    end

    def container_base_classes
      "rounded cursor-pointer flex flex-col gap-1 border-b border-b-gray-200 px-4 pb-4 pt-3 transition-colors bg-white text-gray-500 **:data-title:text-black **:data-ascii-image:text-gray-300 hover:bg-blue-700 inset-ring-4 inset-ring-white"
    end

    def container_hover_classes
      "hover:bg-[#0D37F2] hover:border-b-transparent hover:text-white hover:**:data-title:text-white hover:**:data-ascii-image:text-[#6A86FF] hover:inset-ring-transparent"
    end

    def dom_id
      ActionView::RecordIdentifier.dom_id(event)
    end
  end
end
