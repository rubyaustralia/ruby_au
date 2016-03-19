class MeetupsController < ApplicationController
  def show
    if valid_meetup?
      render template: "meetups/#{params[:id]}"
    else
      raise ActionController::RoutingError, "No such page: #{params[:id]}"
    end
  end

  private

  def valid_meetup?
    File.exist?(Pathname.new(Rails.root + "app/views/meetups/#{params[:id]}.html.erb"))
  end
end
