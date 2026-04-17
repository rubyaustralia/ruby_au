class DashboardDataService
  def initialize
    @cutoff_date = 2.years.ago
  end

  def call
    base_data.merge(membership_stats)
  end

  private

  attr_reader :cutoff_date

  def base_data
    {
      member_count: member_count,
      inactive_members_count: inactive_members.count,
      never_logged_in_members_count: never_logged_in_members.count,
      recently_updated_members: recently_updated_members,
      recently_logged_in_members: recently_logged_in_members,
      recent_posts: recent_posts,
      unpublished_posts: unpublished_posts,
      recent_campaigns: recent_campaigns
    }
  end

  def membership_stats
    {
      new_members_current_month: new_members_for_month(0),
      new_members_prev_month: new_members_for_month(1),
      new_members_two_months_ago: new_members_for_month(2),
      new_members_ytd: new_members_in_range(Time.current.beginning_of_year, Time.current)
    }
  end

  def new_members_for_month(months_ago)
    date = months_ago.months.ago
    new_members_in_range(date.beginning_of_month, months_ago.zero? ? Time.current : date.end_of_month)
  end

  def new_members_in_range(start_date, end_date)
    Membership.where(joined_at: start_date..end_date).count
  end

  def member_count
    User.count
  end

  def inactive_members
    User.where('last_sign_in_at < ? OR last_sign_in_at IS NULL', cutoff_date)
  end

  def never_logged_in_members
    User.includes(:emails).where(last_sign_in_at: nil)
  end

  def recently_updated_members
    User.includes(:emails).order(updated_at: :desc).limit(5)
  end

  def recently_logged_in_members
    User.includes(:emails).where.not(last_sign_in_at: nil).order(last_sign_in_at: :desc).limit(5)
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
