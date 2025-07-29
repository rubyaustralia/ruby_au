# frozen_string_literal: true

module Melbourne
  class ApplicationController < ActionController::Base
    # include helpers from parent app
    helper Rails.application.helpers
  end
end
