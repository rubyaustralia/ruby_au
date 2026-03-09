# frozen_string_literal: true

module Melbourne
  class EventsController < ApplicationController
    def index
      @events = Event.all.reverse
    end

    def show
      event = Event.find_by_slug(params[:slug]) # rubocop:disable Rails/DynamicFindBy
      @event_presenter = EventPresenter.new(event)
    end
  end
end
