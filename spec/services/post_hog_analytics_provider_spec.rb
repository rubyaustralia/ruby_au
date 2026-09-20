require 'rails_helper'

RSpec.describe PostHogAnalyticsProvider do
  subject(:provider) { described_class.new(client) }

  let(:client) { instance_double(PostHogCustomClient, configured?: true) }

  describe '#total_visits' do
    it 'queries total pageviews without placeholder filters' do
      allow(client).to receive(:query).with("SELECT count() FROM events WHERE event = '$pageview'").and_return({
                                                                                                                 'results' => [[42]]
                                                                                                               })

      expect(provider.total_visits).to eq(42)
    end
  end

  describe '#unique_visitors' do
    it 'queries distinct visitors count' do
      allow(client).to receive(:query).with("SELECT count(DISTINCT distinct_id) FROM events").and_return({
                                                                                                           'results' => [[15]]
                                                                                                         })

      expect(provider.unique_visitors).to eq(15)
    end
  end

  describe '#visits_today' do
    it 'queries pageviews from today onwards' do
      allow(client).to receive(:query).with("SELECT count() FROM events WHERE event = '$pageview' AND timestamp >= today()").and_return({
                                                                                                                                          'results' => [[7]]
                                                                                                                                        })

      expect(provider.visits_today).to eq(7)
    end
  end

  describe '#avg_session_duration' do
    it 'queries session duration over the last 30 days using valid interval syntax' do
      allow(client).to receive(:query) do |query|
        expect(query).to include('timestamp >= now() - INTERVAL 30 DAY')
        expect(query).not_to include('30d')
        { 'results' => [[150]] }
      end

      expect(provider.avg_session_duration).to eq('2.5m')
    end
  end

  describe '#top_pages' do
    it 'queries top pages with valid 30-day interval' do
      allow(client).to receive(:query) do |query|
        expect(query).to include('timestamp >= now() - INTERVAL 30 DAY')
        expect(query).not_to include('30d')
        {
          'results' => [
            ['/events', 12],
            ['/', 8]
          ]
        }
      end

      expect(provider.top_pages).to eq({ '/events' => 12, '/' => 8 })
    end
  end

  describe '#visits_over_time' do
    it 'queries visits over time with valid 30-day interval' do
      allow(client).to receive(:query) do |query|
        expect(query).to include('timestamp >= now() - INTERVAL 30 DAY')
        expect(query).not_to include('30d')
        {
          'results' => [
            ['2026-06-01', 10, 8, 25]
          ]
        }
      end

      expect(provider.visits_over_time).to eq(
        [
          { date: 'Jun 01', visits: 10, unique_visitors: 8, page_views: 25 }
        ]
      )
    end
  end

  describe '#device_breakdown' do
    it 'queries device breakdown with valid 30-day interval' do
      allow(client).to receive(:query) do |query|
        expect(query).to include('timestamp >= now() - INTERVAL 30 DAY')
        expect(query).not_to include('30d')
        {
          'results' => [
            ['Desktop', 30],
            ['Mobile', 12]
          ]
        }
      end

      expect(provider.device_breakdown).to eq(
        labels: %w[Desktop Mobile],
        data: [30, 12],
        backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6']
      )
    end
  end

  describe '#recent_visits' do
    it 'queries recent visits with valid 30-day interval and exposes device and country fields' do
      allow(client).to receive(:query) do |query|
        expect(query).to include('timestamp >= now() - INTERVAL 30 DAY')
        expect(query).not_to include('30d')
        {
          'results' => [
            ['abc-123', '2026-06-17T01:02:03Z', '/about', 'Chrome', 'Mac OS X', 'Desktop', 'Australia']
          ]
        }
      end

      visit = provider.recent_visits.first

      expect(visit.visitor_token).to eq('abc-123')
      expect(visit.landing_page).to eq('/about')
      expect(visit.browser).to eq('Chrome')
      expect(visit.device_type).to eq('Desktop')
      expect(visit.country).to eq('Australia')
      expect(visit.started_at).to be_a(ActiveSupport::TimeWithZone)
    end
  end
end
