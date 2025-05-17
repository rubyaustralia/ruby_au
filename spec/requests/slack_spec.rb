require 'rails_helper'

RSpec.describe "Slack Controller", type: :request do
  describe "POST /hook" do
    def post_to_hook(params = {})
      post("/slack/hook", params: params)
    end

    it 'renders forbidden if request is missing slack token' do
      with_slack_app_token
      post_to_hook
      expect(response.status).to eq(403)
    end

    it 'renders forbidden if request has incorrect slack token' do
      with_slack_app_token
      post_to_hook(token: 'not-the-correct-token')
      expect(response.status).to eq(403)
    end

    it 'renders forbidden if no slack token is present in config' do
      post_to_hook(token: 'some-token')
      expect(response.status).to eq(403)
    end

    describe 'with authorized request' do
      let(:base_params) { { token: 'some-token' } }

      before do
        with_slack_app_token
      end

      it 'responds to a challenge request correctly' do
        post_to_hook(base_params.merge(challenge: 'a-challenge'))
        expect(JSON.parse(response.body)['challenge']).to eq('a-challenge')
      end

      it 'passes event_data to event handler' do
        expect(Slack::EventHandler).to receive(:call).with({ event_data: 'event' })
        post_to_hook(base_params.merge(event: 'event'))
      end
    end
  end
end

def with_slack_app_token(token = 'some-token')
  allow(ENV).to receive(:[]).and_call_original
  allow(ENV).to receive(:[]).with('SLACK_APP_TOKEN').and_return(token)
end
