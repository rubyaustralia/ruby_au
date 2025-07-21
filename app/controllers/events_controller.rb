class EventsController < ApplicationController
  def index; end

  def show
    @events = Event.all.order(date: :desc)
    @selected_event = @events.first
  end
end
