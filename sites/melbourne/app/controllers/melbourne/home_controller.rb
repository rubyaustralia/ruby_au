# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @events = Event.all.first(10)
      @selected_event = params[:slug] ? Event.find_by_slug(params[:slug]) : @events.first
    end
  end
end
