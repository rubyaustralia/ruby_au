class Admin::YoutubeAnalyticsController < Admin::ApplicationController
  def index
    @analytics_data = fetch_analytics_data
    @channel_stats = fetch_channel_stats
    @recent_videos = fetch_recent_videos
    @top_videos = fetch_top_videos
  end

  private

  def fetch_analytics_data
    # This would integrate with YouTube Analytics API
    # For now, returning mock data
    {
      views: {
        total: 1_234_567,
        change: 12.5,
        period: 'last_30_days'
      },
      subscribers: {
        total: 45_678,
        change: 8.3,
        period: 'last_30_days'
      },
      watch_time: {
        total: 98_765,
        change: -2.1,
        period: 'last_30_days'
      },
      revenue: {
        total: 2_345.67,
        change: 15.8,
        period: 'last_30_days'
      }
    }
  end

  def fetch_channel_stats
    {
      total_videos: 156,
      total_playlists: 12,
      average_view_duration: '4:32',
      engagement_rate: 4.2
    }
  end

  def fetch_recent_videos
    # Mock data for recent videos
    [
      {
        title: "Ruby on Rails Tutorial - Part 1",
        views: 12_345,
        likes: 234,
        comments: 45,
        published_at: 2.days.ago
      },
      {
        title: "JavaScript Best Practices",
        views: 8_976,
        likes: 187,
        comments: 32,
        published_at: 5.days.ago
      },
      {
        title: "CSS Grid Layout Guide",
        views: 15_432,
        likes: 298,
        comments: 67,
        published_at: 1.week.ago
      }
    ]
  end

  def fetch_top_videos
    # Mock data for top performing videos
    [
      {
        title: "Complete Web Development Course",
        views: 156_789,
        likes: 2_345,
        comments: 456,
        published_at: 2.months.ago
      },
      {
        title: "React Hooks Explained",
        views: 98_765,
        likes: 1_876,
        comments: 234,
        published_at: 1.month.ago
      },
      {
        title: "Database Design Fundamentals",
        views: 87_654,
        likes: 1_543,
        comments: 187,
        published_at: 3.weeks.ago
      }
    ]
  end
end
