class Admin::PostsController < Admin::ApplicationController
  before_action :set_post, only: %i[show edit update]

  def index
    @posts = Post.order(Arel.sql("COALESCE(published_at, publish_scheduled_at) DESC NULLS LAST"))
                 .order(created_at: :desc)
                 .page(params[:page])
  end

  def show; end

  def new
    @post = Post.new
  end

  def edit; end

  def create
    @post = Post.new(post_params.merge(user: current_user))

    if @post.save
      redirect_to admin_post_path(@post), notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      redirect_to admin_post_path(@post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.friendly.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: [:title, :slug, :content, :status, :published_at, :category, :publish_scheduled_at])
  end
end
