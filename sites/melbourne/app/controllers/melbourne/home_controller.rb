# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @next_event = Event.next_event
      @past_events = Event.last(4)

      if @next_event&.in?(@past_events)
        @past_events.shift
      else
        @past_events.pop
      end
    end
  end
end
