class PagesController < ApplicationController
  COMPLEX_VIEWS = %w[
    welcome committee-members previous-committee-members
  ].freeze

  def complex_view?
    COMPLEX_VIEWS.include?(params[:id])
  end

  expose(:sponsors) do
    YAML.load_file Rails.root.join('config/data/sponsors.yml')
  end

  def show
    @posts = Post.published_with_associations.order(published_at: :desc).limit(5) if params[:id] == 'welcome'
    render "pages/#{params[:id]}"
  rescue ActionView::MissingTemplate => e
    if e.message.match?(/Missing template pages#{request.path}/)
      raise ActionController::RoutingError, "No such page: #{params[:id]}"
    else
      raise e
    end
  end
end
