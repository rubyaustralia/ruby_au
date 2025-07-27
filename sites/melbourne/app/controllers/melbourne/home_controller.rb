# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @events = Event.all
      today = Date.current
      @upcoming_events = @events.select { |event| event.date >= today }
      @past_events = @events.select { |event| event.date < today }
      @selected_event = @upcoming_events.first
    end
  end
end
