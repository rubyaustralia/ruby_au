require 'csv'

class AnalyticsCsvExporter
  def initialize(analytics_data)
    @analytics_data = analytics_data
  end

  def generate
    CSV.generate(headers: true) do |csv|
      csv << headers
      add_data_rows(csv)
    end
  end

  def filename
    "analytics_export_#{Date.current}.csv"
  end

  private

  attr_reader :analytics_data

  def headers
    ['Date', 'Visits', 'Unique Visitors', 'Page Views']
  end

  def add_data_rows(csv)
    visits = analytics_data.respond_to?(:visits_over_time) ? analytics_data.visits_over_time : []
    return if visits.blank?

    visits.each do |day_data|
      csv << build_row(day_data)
    end
  end

  def build_row(day_data)
    date = parse_date(fetch_value(day_data, :date))
    visits = fetch_value(day_data, :visits, 0)
    unique_visitors = fetch_value(day_data, :unique_visitors, visits)
    page_views = fetch_value(day_data, :page_views, visits)

    [
      date,
      visits,
      unique_visitors,
      page_views
    ]
  end

  def parse_date(date_value)
    return date_value if date_value.is_a?(Date)

    Date.parse(date_value.to_s.include?(' ') ? "#{date_value} #{Date.current.year}" : date_value.to_s)
  rescue ArgumentError, TypeError
    date_value.to_s
  end

  def fetch_value(data, key, default = nil)
    if data.is_a?(Hash)
      data[key] || data[key.to_s] || default
    elsif data.respond_to?(key)
      data.public_send(key) || default
    else
      default
    end
  end
end
