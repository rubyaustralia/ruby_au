# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @next_event = Event.next_event
      @past_events = Event.past(4)
    end
  end
end
