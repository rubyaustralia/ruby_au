require 'rails_helper'

RSpec.describe AnalyticsService do
  subject(:analytics_service) { described_class.new(provider) }

  let(:provider) { instance_double(PostHogAnalyticsProvider) }

  before do
    allow(provider).to receive_messages(
      total_visits: 100,
      unique_visitors: 50,
      visits_today: 10,
      total_page_views: 200,
      avg_session_duration: "2.5m",
      top_pages: { "/" => 150, "/about" => 50 },
      visits_over_time: [{ date: "Jun 01", visits: 10 }],
      device_breakdown: { labels: ["Desktop"], data: [100], backgroundColor: ["#3B82F6"] },
      recent_visits: [],
      configured?: true
    )
  end

  describe '#call' do
    it 'returns an OpenStruct with all required metrics' do
      result = analytics_service.call

      expect(result.total_visits).to eq(100)
      expect(result.unique_visitors).to eq(50)
      expect(result.visits_today).to eq(10)
      expect(result.total_page_views).to eq(200)
      expect(result.avg_session_duration).to eq("2.5m")
      expect(result.top_pages).to eq({ "/" => 150, "/about" => 50 })
      expect(result.visits_over_time).to eq([{ date: "Jun 01", visits: 10 }])
      expect(result.device_breakdown).to eq({ labels: ["Desktop"], data: [100], backgroundColor: ["#3B82F6"] })
      expect(result.status[:configured]).to be true
    end
  end
end
