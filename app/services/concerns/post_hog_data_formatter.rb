# frozen_string_literal: true

module PostHogDataFormatter
  private

  def format_visit_row(row)
    {
      date: Time.zone.parse(row[0].to_s).strftime("%b %d"),
      visits: row[1]
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
      "#{(seconds / 60).round(1)}m"
    end
  end
end
