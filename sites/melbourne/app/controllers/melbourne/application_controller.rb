# frozen_string_literal: true

module Melbourne
  class ApplicationController < ActionController::Base
    before_action :load_events

    private

    def load_events
      @events = Event.all.first(20)
      @selected_event = @events.first unless @selected_event
    end
  end
end
