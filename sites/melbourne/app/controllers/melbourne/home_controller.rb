# frozen_string_literal: true

module Melbourne
  class HomeController < ApplicationController
    def show
      @events = Event.all.first(3)
    end
  end
end
