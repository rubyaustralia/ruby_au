class PostHogAnalyticsProvider
  include PostHogMockData
  include PostHogHogqlQueries
  include PostHogDataFormatter

  def initialize(client = nil)
    @client = client || PostHogCustomClient.new
  end

  delegate :configured?, to: :@client

  def total_visits
    return mock_total_visits if mock_mode?

    results = @client.query("SELECT count() FROM events WHERE event = '$pageview' AND {filters}")
    extract_single_value(results)
  end

  def unique_visitors
    return mock_unique_visitors if mock_mode?

    results = @client.query("SELECT count(DISTINCT distinct_id) FROM events WHERE {filters}")
    extract_single_value(results)
  end

  def visits_today
    return mock_visits_today if mock_mode?

    results = @client.query("SELECT count() FROM events WHERE event = '$pageview' AND timestamp >= today() AND {filters}")
    extract_single_value(results)
  end

  def total_page_views
    return mock_total_page_views if mock_mode?

    total_visits
  end

  def avg_session_duration
    return mock_avg_session_duration if mock_mode?

    results = @client.query(avg_session_duration_hogql)
    duration = extract_single_value(results) || 0
    format_duration(duration)
  end

  def top_pages
    return mock_top_pages if mock_mode?

    results = @client.query(top_pages_hogql)
    return {} unless results['results']

    results['results'].to_h { |row| [row[0] || '/', row[1]] }
  end

  def visits_over_time
    return mock_visits_over_time if mock_mode?

    results = @client.query(visits_over_time_hogql)
    return [] unless results['results']

    results['results'].map { |row| format_visit_row(row) }
  end

  def device_breakdown
    return mock_device_breakdown if mock_mode?

    results = @client.query(device_breakdown_hogql)
    return empty_device_breakdown unless results['results']

    format_device_results(results['results'])
  end

  def recent_visits
    return mock_recent_visits if mock_mode?

    results = @client.query(recent_visits_hogql)
    return [] unless results['results']

    results['results'].map { |row| format_recent_visit_row(row) }
  end

  private

  def mock_mode?
    Rails.env.development? && !configured?
  end

  def extract_single_value(results)
    return 0 unless results['results'] && results['results'][0]

    results['results'][0][0]
  end
end
