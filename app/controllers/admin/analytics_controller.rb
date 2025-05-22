class Admin::AnalyticsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @total_visits = Ahoy::Visit.count
    @unique_visitors = Ahoy::Visit.distinct.count(:visitor_token)
    @visits_today = Ahoy::Visit.where("started_at >= ?", Date.current).count
    @total_page_views = Ahoy::Event.where(name: "$view").count

    @avg_session_duration = calculate_avg_session_duration

    @top_pages = Ahoy::Event.where(name: "$view")
                            .where("time >= ?", 30.days.ago)
                            .group("properties->>'url'")
                            .count
                            .sort_by { |k, v| -v }
                            .first(10)

    @visits_over_time = visits_over_time_data
    @device_breakdown = device_breakdown_data
    @recent_visits = Ahoy::Visit.includes(:events)
                                .order(started_at: :desc)
                                .limit(10)

    respond_to do |format|
      format.html
      format.csv { send_csv_export }
    end
  end

  private

  def calculate_avg_session_duration
    durations = Ahoy::Visit.where.not(started_at: nil)
                           .where("started_at >= ?", 30.days.ago)
                           .joins(:events)
                           .group(:id)
                           .maximum('ahoy_events.time')
                           .map { |visit_id, last_event_time|
                             visit = Ahoy::Visit.find(visit_id)
                             next nil unless last_event_time && visit.started_at

                             ((last_event_time - visit.started_at) / 60).round(2) # minutes
                           }
                           .compact

    return "0m" if durations.empty?

    avg_minutes = durations.sum / durations.size
    "#{avg_minutes.round(1)}m"
  end

  def visits_over_time_data
    # Get visits for the last 30 days, grouped by day
    visits_by_day = Ahoy::Visit.where("started_at >= ?", 30.days.ago)
                               .group("DATE(started_at)")
                               .count

    # Fill in missing days with 0
    (30.days.ago.to_date..Date.current).map do |date|
      {
        date: date.strftime("%b %d"),
        visits: visits_by_day[date.to_s] || 0
      }
    end
  end

  def device_breakdown_data
    device_counts = Ahoy::Visit.where("started_at >= ?", 30.days.ago)
                               .group(:device_type)
                               .count

    # Handle nil device types
    device_counts["Unknown"] = device_counts.delete(nil) if device_counts[nil]

    {
      labels: device_counts.keys.map(&:titleize),
      data: device_counts.values,
      backgroundColor: [
        '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6'
      ]
    }
  end

  def send_csv_export
    csv_data = CSV.generate(headers: true) do |csv|
      csv << ['Date', 'Visits', 'Unique Visitors', 'Page Views']

      @visits_over_time.each do |day_data|
        date = Date.parse(day_data[:date] + " #{Date.current.year}")
        daily_visitors = Ahoy::Visit.where(started_at: date.beginning_of_day..date.end_of_day)
                                    .distinct
                                    .count(:visitor_token)
        daily_page_views = Ahoy::Event.where(name: "$view")
                                      .where(time: date.beginning_of_day..date.end_of_day)
                                      .count

        csv << [date, day_data[:visits], daily_visitors, daily_page_views]
      end
    end

    send_data csv_data,
              filename: "analytics_export_#{Date.current}.csv",
              type: 'text/csv'
  end
end