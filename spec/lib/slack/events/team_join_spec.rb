require 'rails_helper'

RSpec.describe Slack::Events::TeamJoin do
  include ActionMailer::TestHelper

  describe '.call' do
    subject(:call) { described_class.call(event_data) }

    let(:event_data) do
      {
        user: {
          realname: 'John Doe',
          profile: {
            email: 'john.doe@email.com'
          }
        }
      }
    end

    it 'skips sending an email when email is missing from event data' do
      assert_no_emails { described_class.call }
    end

    it 'skips sending an email when a user exists with the provided email' do
      create(:user, email: 'john.doe@email.com')

      assert_no_emails { described_class.call }
    end

    it 'sends an email' do
      assert_emails(1) { described_class.call(event_data) }
    end
  end
end
