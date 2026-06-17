# frozen_string_literal: true

module PostHogHogqlQueries
  private

  def avg_session_duration_hogql
    <<~SQL
      SELECT avg(session_duration)
      FROM (
        SELECT session_id, max(timestamp) - min(timestamp) as session_duration
        FROM events
        WHERE session_id IS NOT NULL AND timestamp >= 30d
        GROUP BY session_id
      )
    SQL
  end

  def top_pages_hogql
    <<~SQL
      SELECT properties.$path, count() as views
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      GROUP BY properties.$path
      ORDER BY views DESC
      LIMIT 10
    SQL
  end

  def visits_over_time_hogql
    <<~SQL
      SELECT toDate(timestamp) as date, count() as visits
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      GROUP BY date
      ORDER BY date ASC
    SQL
  end

  def device_breakdown_hogql
    <<~SQL
      SELECT properties.$device_type, count() as count
      FROM events
      WHERE timestamp >= 30d
      GROUP BY properties.$device_type
    SQL
  end

  def recent_visits_hogql
    <<~SQL
      SELECT distinct_id, timestamp, properties.$path, properties.$browser, properties.$os
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      ORDER BY timestamp DESC
      LIMIT 10
    SQL
  end
end
