class SponsorsController < ApplicationController
  before_action :sponsors

  def index
    # @sponsors is already loaded by before_action
  end

  def show
    @sponsor = @sponsors.find { |sponsor| sponsor['key'] == params[:id] }

    return if @sponsor

    raise ActionController::RoutingError, "No such sponsor: #{params[:id]}"
  end

  private

  def sponsors
    @sponsors ||= YAML.load_file(Rails.root.join('config/data/sponsors.yml'))
  end
end
