require 'rails_helper'

RSpec.describe Slack::EventHandler do
  describe '.call' do
    it 'requires event_data argument' do
      expect { described_class.call }.to raise_error(ArgumentError, "missing keyword: :event_data")
    end

    it 'returns false for an unrecognized event' do
      expect(described_class.call(event_data: { type: 'not_an_event' })).to be_falsey
    end

    it 'defers to event class based on event_type' do
      some_event = stub_const(
        'Slack::Events::SomeEvent',
        class_double('SomeEvent')
      )

      expect(some_event).to receive(:call)

      described_class.call(event_data: { type: 'some_event' })
    end
  end
end
