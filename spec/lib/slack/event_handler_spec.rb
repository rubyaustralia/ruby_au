require 'rails_helper'

RSpec.describe Slack::EventHandler do
  describe '.call' do
    let(:event_data) do
      { type: 'team_join' }
    end

    it 'defers to event class based on event_type' do
      allow(Slack::Events::TeamJoin).to receive(:call)

      described_class.call(event_data: event_data)

      expect(Slack::Events::TeamJoin).to have_received(:call).with(event_data)
    end
  end
end
