class AnalyticsService
  def initialize(provider = nil)
    @provider = provider || PostHogAnalyticsProvider.new
  end

  def call
    OpenStruct.new(basic_metrics.merge(detailed_metrics).merge(status: status))
  end

  private

  def status
    {
      configured: @provider.configured?
    }
  end

  def basic_metrics
    {
      total_visits: @provider.total_visits,
      unique_visitors: @provider.unique_visitors,
      visits_today: @provider.visits_today,
      total_page_views: @provider.total_page_views,
      avg_session_duration: @provider.avg_session_duration
    }
  end

  def detailed_metrics
    {
      top_pages: @provider.top_pages,
      visits_over_time: @provider.visits_over_time,
      device_breakdown: @provider.device_breakdown,
      recent_visits: @provider.recent_visits
    }
  end
end
