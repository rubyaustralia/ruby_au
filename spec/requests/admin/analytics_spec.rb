require 'rails_helper'

RSpec.describe 'Admin::Analytics', type: :request do
  let(:admin) { create(:user, :committee) }

  before do
    sign_in admin
    stub_request(:post, %r{https://.*/api/projects/.*/query/})
      .to_return(
        status: 200,
        body: { 'results' => [] }.to_json,
        headers: { 'Content-Type' => 'application/json' }
      )
  end

  describe 'GET /admin/analytics' do
    it 'renders the analytics dashboard successfully' do
      get admin_analytics_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Analytics Dashboard')
      expect(response.body).to include('Visits Over Time (Last 30 Days)')
      expect(response.body).to include('Device Types')
      expect(response.body).to include('Top Pages')
      expect(response.body).to include('Recent Activity')
    end

    it 'handles CSV export format' do
      get admin_analytics_path(format: :csv)

      expect(response).to have_http_status(:ok)
      expect(response.header['Content-Type']).to include('text/csv')
      expect(response.body).to include('Date,Visits,Unique Visitors,Page Views')
    end
  end
end
