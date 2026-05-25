# frozen_string_literal: true

module Melbourne
  class TestsController < ApplicationController
    def index
      @events = Event.all.reverse
    end
  end
end
