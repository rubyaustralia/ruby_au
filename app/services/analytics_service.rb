class AnalyticsService
  def call
    OpenStruct.new(basic_metrics.merge(detailed_metrics))
  end

  private

  def basic_metrics
    {
      total_visits: total_visits,
      unique_visitors: unique_visitors,
      visits_today: visits_today,
      total_page_views: total_page_views,
      avg_session_duration: avg_session_duration
    }
  end

  def detailed_metrics
    {
      top_pages: top_pages,
      visits_over_time: visits_over_time,
      device_breakdown: device_breakdown,
      recent_visits: recent_visits
    }
  end

  def total_visits
    @total_visits ||= Ahoy::Visit.count
  end

  def unique_visitors
    @unique_visitors ||= Ahoy::Visit.distinct.count(:visitor_token)
  end

  def visits_today
    @visits_today ||= Ahoy::Visit.where("started_at >= ?", Date.current).count
  end

  def total_page_views
    @total_page_views ||= Ahoy::Event.where(name: "$view").count
  end

  def avg_session_duration
    @avg_session_duration ||= SessionDurationCalculator.new.call
  end

  def top_pages
    @top_pages ||= TopPagesCalculator.new.call
  end

  def visits_over_time
    @visits_over_time ||= VisitsOverTimeCalculator.new.call
  end

  def device_breakdown
    @device_breakdown ||= DeviceBreakdownCalculator.new.call
  end

  def recent_visits
    @recent_visits ||= Ahoy::Visit.includes(:events)
                                  .order(started_at: :desc)
                                  .limit(10)
  end
end
