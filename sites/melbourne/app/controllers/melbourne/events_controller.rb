# frozen_string_literal: true

module Melbourne
  class EventsController < ApplicationController
    def show
      @events = Event.all
      @event = Event.find_by_slug(params[:slug]) # rubocop:disable Rails/DynamicFindBy
    end
  end
end
