module Admin
  class DashboardsController < ApplicationController
    before_action :authenticate_user!
    before_action :confirm_is_committee!

    def show
      @member_count = User.count
      @recently_updated_members = User.order(updated_at: :desc).limit(5)
      @recently_logged_in_members = User.where.not(last_sign_in_at: nil).order(last_sign_in_at: :desc).limit(5)
      @recent_posts = Post.order(created_at: :desc).limit(3)
      @unpublished_posts = Post.where(published_at: nil).order(created_at: :desc)
      @recent_campaigns = Campaign.order(created_at: :desc).limit(5)
      @inactive_members = User.where('last_sign_in_at < ?', 2.years.ago)
      @never_logged_in_members = User.where(last_sign_in_at: nil)
    end
  end
end
