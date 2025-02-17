require 'rails_helper'

RSpec.describe Posts::Publisher do
  describe '.call' do
    subject(:publish) { described_class.call(post) }

    context 'when post is not publishable' do
      let(:post) { create(:post, :draft) }

      it 'does not schedule a publish job' do
        expect { publish }.not_to have_enqueued_job(PublishPostJob)
      end
    end

    context 'when post is already scheduled' do
      let(:post) { create(:post, :scheduled) }

      it 'does not schedule another publish job' do
        expect { publish }.not_to have_enqueued_job(PublishPostJob)
      end
    end

    context 'with a publishable post' do
      let(:post) { create(:post, :publishable) }
      let(:scheduled_time) { post.publish_scheduled_at }

      it 'schedules a publish job' do
        expect { publish }
          .to have_enqueued_job(PublishPostJob)
          .with(post)
          .at(scheduled_time)
      end
    end

    context 'when rescheduling a post' do
      let(:post) { create(:post, :scheduled) }
      let(:new_time) { 2.days.from_now }

      before do
        post.publish_scheduled_at = new_time
      end

      it 'does not schedule a new job' do
        expect { publish }.not_to have_enqueued_job(PublishPostJob)
      end
    end
  end
end
