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
    analytics_data.visits_over_time.each do |day_data|
      csv << build_row(day_data)
    end
  end

  def build_row(day_data)
    date = parse_date(day_data[:date])
    [
      date,
      day_data[:visits],
      daily_unique_visitors(date),
      daily_page_views(date)
    ]
  end

  def parse_date(date_string)
    Date.parse("#{date_string} #{Date.current.year}")
  end

  def daily_unique_visitors(date)
    Ahoy::Visit.where(started_at: date.beginning_of_day..date.end_of_day)
               .distinct
               .count(:visitor_token)
  end

  def daily_page_views(date)
    Ahoy::Event.where(name: "$view")
               .where(time: date.beginning_of_day..date.end_of_day)
               .count
  end
end
