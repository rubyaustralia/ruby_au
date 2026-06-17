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
      SELECT
        coalesce(
          nullIf(properties.$pathname, ''),
          path(properties.$current_url),
          '/'
        ) as page_path,
        count() as views
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      GROUP BY page_path
      ORDER BY views DESC
      LIMIT 10
    SQL
  end

  def visits_over_time_hogql
    <<~SQL
      SELECT toDate(timestamp) as date, count(DISTINCT distinct_id) as visits
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      GROUP BY date
      ORDER BY date ASC
    SQL
  end

  def device_breakdown_hogql
    <<~SQL
      SELECT coalesce(nullIf(properties.$device_type, ''), 'Unknown') as device_type, count() as count
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      GROUP BY device_type
    SQL
  end

  def recent_visits_hogql
    <<~SQL
      SELECT
        distinct_id,
        timestamp,
        coalesce(nullIf(properties.$pathname, ''), path(properties.$current_url), '/') as page_path,
        properties.$browser,
        properties.$os,
        coalesce(nullIf(properties.$device_type, ''), 'Unknown') as device_type,
        nullIf(properties.$geoip_country_name, '') as country
      FROM events
      WHERE event = '$pageview' AND timestamp >= 30d
      ORDER BY timestamp DESC
      LIMIT 10
    SQL
  end
end
