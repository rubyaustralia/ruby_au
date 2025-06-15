class DashboardDataService
  def initialize
    @cutoff_date = 2.years.ago
  end

  def call
    {
      member_count: member_count,
      inactive_members: inactive_members,
      never_logged_in_members: never_logged_in_members,
      recently_updated_members: recently_updated_members,
      recently_logged_in_members: recently_logged_in_members,
      recent_posts: recent_posts,
      unpublished_posts: unpublished_posts,
      recent_campaigns: recent_campaigns
    }
  end

  private

  attr_reader :cutoff_date

  def member_count
    User.count
  end

  def inactive_members
    User.where('last_sign_in_at < ? OR last_sign_in_at IS NULL', cutoff_date)
  end

  def never_logged_in_members
    User.where(last_sign_in_at: nil)
  end

  def recently_updated_members
    User.order(updated_at: :desc).limit(5)
  end

  def recently_logged_in_members
    User.where.not(last_sign_in_at: nil).order(last_sign_in_at: :desc).limit(5)
  end

  def recent_posts
    Post.published.recent.limit(5)
  end

  def unpublished_posts
    Post.draft.recent.limit(5)
  end

  def recent_campaigns
    defined?(Campaign) ? Campaign.recent.limit(5) : []
  end
end
