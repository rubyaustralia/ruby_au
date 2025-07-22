# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @events = Event.all
      @selected_event = @events.first
    end
  end
end
