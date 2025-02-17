require 'rails_helper'

RSpec.describe PublishPostJob, type: :job do
  let(:post) { create(:post) }

  describe '#perform' do
    context 'when post is publishable' do
      let(:post) { create(:post, publish_scheduled_at: 1.day.ago) }
      it 'publishes the post' do
        expect do
          PublishPostJob.new.perform(post)
        end.to change { post.reload.published? }.from(false).to(true)
      end
    end

    context 'when post is not publishable' do
      let(:post) { create(:post, :published) }
      it 'does not publish the post' do
        expect(post.published?).to be(true)
        expect do
          PublishPostJob.new.perform(post)
        end.to_not(change { post.reload.published? })
      end
    end
  end
end
