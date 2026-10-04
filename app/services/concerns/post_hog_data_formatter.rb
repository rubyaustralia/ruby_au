# frozen_string_literal: true

module PostHogDataFormatter
  private

  def format_visits_over_time(results)
    results_by_date = index_results_by_date(results)
    timeline_date_range.map do |date|
      build_timeline_day(date, results_by_date[date])
    end
  end

  def timeline_date_range
    29.days.ago.to_date..Time.zone.today
  end

  def index_results_by_date(results)
    (results || []).each_with_object({}) do |row, hash|
      date_key = Time.zone.parse(row[0].to_s)&.to_date
      hash[date_key] = extract_visit_metrics(row) if date_key
    end
  end

  def extract_visit_metrics(row)
    {
      visits: row[1].to_i,
      unique_visitors: (row[2] || row[1]).to_i,
      page_views: (row[3] || row[1]).to_i
    }
  end

  def build_timeline_day(date, data)
    {
      date: date.strftime("%b %d"),
      visits: data&.fetch(:visits, 0) || 0,
      unique_visitors: data&.fetch(:unique_visitors, 0) || 0,
      page_views: data&.fetch(:page_views, 0) || 0
    }
  end

  def empty_device_breakdown
    { labels: [], data: [], backgroundColor: [] }
  end

  def format_device_results(results)
    labels = results.map { |row| (row[0] || 'Unknown').to_s.titleize }
    data = results.map { |row| row[1] }

    {
      labels: labels,
      data: data,
      backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6']
    }
  end

  def format_recent_visit_row(row)
    OpenStruct.new(
      visitor_token: row[0],
      started_at: Time.zone.parse(row[1].to_s),
      landing_page: row[2],
      browser: row[3],
      os: row[4],
      device_type: row[5],
      country: row[6],
      events: []
    )
  end

  def format_duration(seconds)
    return "0m" if seconds <= 0

    if seconds < 1
      "< 1s"
    elsif seconds < 60
      "#{seconds.round(0)}s"
    else
      "#{(seconds.to_f / 60).round(1)}m"
    end
  end
end
