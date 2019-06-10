class SponsorsController < ApplicationController
  rescue_from ActionView::MissingTemplate do |exception|
    raise ActionController::RoutingError, "No such page: #{params[:id]}" if exception.message.match?(/Missing template pages#{request.path}/)

    raise exception
  end
end
