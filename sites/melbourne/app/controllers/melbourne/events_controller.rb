# frozen_string_literal: true

module Melbourne
  class EventsController < ApplicationController
    def show
      @events = Event.all
      @event = Event.find_by_slug(params[:slug]) # rubocop:disable Rails/DynamicFindBy
      today = Date.current
      @upcoming_events = @events.select { |event| event.date >= today }
      @past_events = @events.select { |event| event.date < today }
      @selected_event = @event
    end
  end
end
