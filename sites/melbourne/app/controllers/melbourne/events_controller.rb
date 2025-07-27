# frozen_string_literal: true

module Melbourne
  class EventsController < ApplicationController
    def index
      @events = Event.all
    end

    def show
      @event = Event.find_by_slug(params[:slug]) # rubocop:disable Rails/DynamicFindBy
    end
  end
end
