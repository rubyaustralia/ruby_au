# frozen_string_literal: true

module Melbourne
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :exception
  end
end
