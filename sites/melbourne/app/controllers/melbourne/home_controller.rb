# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @events = Event.all.first(20)
      @selected_event = @events.first
    end
  end
end
