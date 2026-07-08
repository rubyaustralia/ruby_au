# frozen_string_literal: true

module Melbourne
  class DatabaseEventsController < ApplicationController
    def index
      @database_events = DatabaseEvent.all.reverse
    end

    def show
      database_event = DatabaseEvent.find_by_slug(params[:slug]) # rubocop:disable Rails/DynamicFindBy
      @event_presenter = EventPresenter.new(database_event)
    end
  end
end
