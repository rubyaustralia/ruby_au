# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @next_event = Event.next_event
      @latest_events = Event.last(4)

      if @next_event && @next_event.in?(@latest_events)
        @latest_events.shift
      else
        @latest_events.pop
      end
    end
  end
end
