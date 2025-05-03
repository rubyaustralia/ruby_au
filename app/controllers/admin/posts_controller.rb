class Admin::PostsController < Admin::ApplicationController
  before_action :set_post, only: %i[show edit update archive destroy]
  helper :posts

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
      Posts::Publisher.call(@post)
      redirect_to admin_post_path(@post), notice: "Post was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @post.update(post_params)
      Posts::Publisher.call(@post)
      redirect_to admin_post_path(@post), notice: "Post was successfully updated."
    else
      render :edit, status: :unprocessable_entity, alert: "Post could not be updated due to #{@post.errors.full_messages.to_sentence}."
    end
  end

  def archive
    if @post.archive
      redirect_to admin_posts_path, notice: "Post was successfully archived."
    else
      flash[:alter] = "Post could not be archived due to #{@post.errors.full_messages.to_sentence}."
      redirect_back fallback_location: admin_posts_path
    end
  end

  def destroy
    if @post.destroy
      redirect_to admin_posts_path, notice: "Post was successfully deleted."
    else
      flash[:alter] = "Post could not be deleted due to #{@post.errors.full_messages.to_sentence}."
      redirect_back fallback_location: admin_posts_path
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.friendly.find(params.expect(:slug))
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_posts_path, alert: "Post '#{params[:slug]}' is not found"
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.expect(post: [:title, :slug, :content, :status, :published_at, :category, :publish_scheduled_at])
  end
end
