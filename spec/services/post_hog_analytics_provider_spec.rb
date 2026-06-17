require 'rails_helper'

RSpec.describe PostHogAnalyticsProvider do
  subject(:provider) { described_class.new(client) }

  let(:client) { instance_double(PostHogCustomClient, configured?: true) }

  describe '#top_pages' do
    it 'returns page counts from query rows' do
      allow(client).to receive(:query).and_return({
                                                    'results' => [
                                                      ['/events', 12],
                                                      ['/', 8]
                                                    ]
                                                  })

      expect(provider.top_pages).to eq({ '/events' => 12, '/' => 8 })
    end
  end

  describe '#device_breakdown' do
    it 'returns chart data from query rows' do
      allow(client).to receive(:query).and_return({
                                                    'results' => [
                                                      ['Desktop', 30],
                                                      ['Mobile', 12]
                                                    ]
                                                  })

      expect(provider.device_breakdown).to eq(
        labels: %w[Desktop Mobile],
        data: [30, 12],
        backgroundColor: ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6']
      )
    end
  end

  describe '#recent_visits' do
    it 'exposes device and country fields for recent activity rows' do
      allow(client).to receive(:query).and_return({
                                                    'results' => [
                                                      ['abc-123', '2026-06-17T01:02:03Z', '/about', 'Chrome', 'Mac OS X', 'Desktop', 'Australia']
                                                    ]
                                                  })

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
