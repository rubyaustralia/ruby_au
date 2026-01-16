class PostsController < ApplicationController
  expose(:complex_view?) { true }

  before_action :set_post, only: %i[show]

  def index
    @posts = Post.published_with_associations
                 .filter_by_category(params[:category])
                 .page(params[:page])
  end

  def feed
    @posts = Post.published_with_associations

    respond_to do |format|
      format.html
      format.rss { render layout: false }
    end
  end

  def show; end

  private

  def set_post
    slug = params.expect(:slug)
    @post = Post.friendly.find(slug)
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, flash: { error: "Post '#{slug}' is not found" }
  end
end
