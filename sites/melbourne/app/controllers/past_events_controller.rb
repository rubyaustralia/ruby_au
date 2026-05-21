module Melbourne
  class PastEventsController < ApplicationController
    def index
      @events = Event.past
    end
  end
end
