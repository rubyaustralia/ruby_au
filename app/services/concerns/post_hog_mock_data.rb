# frozen_string_literal: true

module PostHogMockData
  def mock_total_visits
    1250
  end

  def mock_unique_visitors
    840
  end

  def mock_visits_today
    42
  end

  def mock_total_page_views
    3100
  end

  def mock_avg_session_duration
    "2.5m"
  end

  def mock_top_pages
    {
      "/" => 1200,
      "/posts/1" => 450,
      "/about" => 300,
      "/contact" => 150
    }
  end

  def mock_visits_over_time
    (0..29).map do |i|
      {
        date: (Time.zone.today - (29 - i)).strftime("%b %d"),
        visits: rand(20..100)
      }
    end
  end

  def mock_device_breakdown
    {
      labels: %w[Desktop Mobile Tablet],
      data: [65, 25, 10],
      backgroundColor: ["#3B82F6", "#10B981", "#F59E0B"]
    }
  end

  def mock_recent_visits
    [
      create_mock_visit(token: "mock-1", time: 10.minutes.ago, page: "/", browser: "Chrome", os: "Mac OS X", device: "Desktop"),
      create_mock_visit(token: "mock-2", time: 25.minutes.ago, page: "/posts/1", browser: "Safari", os: "iOS", device: "Mobile")
    ]
  end

  private

  def create_mock_visit(attributes)
    OpenStruct.new(
      visitor_token: attributes[:token],
      started_at: attributes[:time],
      landing_page: attributes[:page],
      browser: attributes[:browser],
      os: attributes[:os],
      device_type: attributes[:device],
      country: "Australia"
    )
  end
end
