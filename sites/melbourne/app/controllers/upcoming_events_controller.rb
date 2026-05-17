module Melbourne
  class UpcomingEventsController < ApplicationController
    def index
      @events = Event.upcoming
    end
  end
end
