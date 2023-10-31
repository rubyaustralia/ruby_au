class PagesController < ApplicationController
  COMPLEX_VIEWS = %w[
    welcome committee-members previous-committee-members
  ].freeze

  expose(:complex_view?) { COMPLEX_VIEWS.include? params[:id] }

  expose(:sponsors) do
    YAML.load_file Rails.root.join('config/data/sponsors.yml')
  end

  rescue_from ActionView::MissingTemplate do |exception|
    if exception.message.match?(/Missing template pages#{request.path}/)
      raise ActionController::RoutingError, "No such page: #{params[:id]}"
    else
      raise exception
    end
  end

  def show
    render "pages/#{params[:id]}"
  end
end
