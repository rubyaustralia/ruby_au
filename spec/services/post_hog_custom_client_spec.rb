require 'rails_helper'

RSpec.describe PostHogCustomClient do
  subject(:client) { described_class.new }

  let(:credentials) do
    {
      POSTHOG_PERSONAL_API_KEY: personal_api_key,
      POSTHOG_PROJECT_ID: project_id,
      POSTHOG_HOST: 'https://us.posthog.com'
    }
  end
  let(:personal_api_key) { 'phx_personal_key' }
  let(:project_id) { '468445' }

  before do
    allow(Rails.application).to receive(:credentials).and_return(credentials)
  end

  describe '#configured?' do
    it 'is true when personal API key and project id are present' do
      expect(client.configured?).to be true
    end

    context 'when project id is a host URL value' do
      let(:project_id) { 'https://us.posthog.com' }

      it 'is false' do
        expect(client.configured?).to be false
      end
    end
  end

  describe '#query' do
    context 'when not configured' do
      let(:project_id) { nil }

      it 'returns an empty hash' do
        expect(client.query('SELECT 1')).to eq({})
      end
    end
  end
end
