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
    if params[:id] == 'welcome'
      @posts = Post.published_with_associations.order(published_at: :desc).limit(5)
    end
    render "pages/#{params[:id]}"
  rescue ActionView::MissingTemplate => exception
    if exception.message.match?(/Missing template pages#{request.path}/)
      raise ActionController::RoutingError, "No such page: #{params[:id]}"
    else
      raise exception
    end
  end
end
