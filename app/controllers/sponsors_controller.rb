class SponsorsController < ApplicationController
  expose(:sponsors) do
    YAML.load_file Rails.root.join('config', 'data', 'sponsors.yml')
  end

  expose(:sponsor) do
    sponsors.detect { |hash| hash['key'] == params[:id] }
  end

  def show
    return unless sponsor.nil?

    raise ActionController::RoutingError, "No such page: #{params[:id]}"
  end
end
