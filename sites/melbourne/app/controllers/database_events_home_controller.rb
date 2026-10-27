# frozen_string_literal: true

module Melbourne
  class DatabaseEventsHomeController < ApplicationController
    def show
      @next_event = DatabaseEvent.upcoming(1).first
      @past_events = DatabaseEvent.past(4)
    end
  end
end
