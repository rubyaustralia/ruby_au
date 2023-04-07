require 'rails_helper'

RSpec.describe "Slack Controller", type: :request do
  describe "POST /hook" do
    subject(:hook) { post("/slack/hook", params: @params) }

    it 'renders forbidden if request is missing slack token' do
      with_slack_app_token

      hook

      expect(response.status).to eq(403)
    end

    it 'renders forbidden if request has incorrect slack token' do
      with_slack_app_token

      @params = {
        token: 'not-the-correct-token'
      }

      hook

      expect(response.status).to eq(403)
    end

    it 'renders forbidden if no slack token is present in config' do
      @params = {
        token: 'some-token'
      }

      hook

      expect(response.status).to eq(403)
    end

    describe 'with authorized request' do
      before(:each) do
        with_slack_app_token
        @params = {
          token: 'some-token',
        }
      end

      it 'responds to a challenge request correctly' do
        @params = @params.merge({ challenge: 'a-challenge' })
        hook

        expect(JSON.parse(response.body)['challenge']).to eq('a-challenge')
      end

      it 'passes event_data to event handler' do
        @params = @params.merge({ event: 'event' })

        expect(Slack::EventHandler).to receive(:call).with({ event_data: 'event' })

        hook
      end
    end
  end
end

private

def with_slack_app_token(token = 'some-token')\
  allow(ENV).to receive(:[]).and_call_original
  allow(ENV).to receive(:[]).with('SLACK_APP_TOKEN').and_return(token)
end
