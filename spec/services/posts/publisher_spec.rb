require 'rails_helper'

RSpec.describe Posts::Publisher do
  let(:user) { create(:user) }

  describe '.call' do
    context 'when post is draft and publish_scheduled_at is in the past' do
      let(:post) do
        create(:post,
               status: :draft,
               publish_scheduled_at: 1.hour.ago,
               user: user)
      end

      it 'publishes the post' do
        described_class.call(post)
        expect(post.reload).to be_published
        expect(post.published_at).to be_present
      end
    end

    context 'when post is draft but publish_scheduled_at is in the future' do
      let(:post) do
        create(:post,
               status: :draft,
               publish_scheduled_at: 1.hour.from_now,
               user: user)
      end

      it 'does not publish the post' do
        described_class.call(post)
        expect(post.reload).to be_draft
        expect(post.published_at).to be_nil
      end
    end

    context 'when post is not draft' do
      let(:post) do
        create(:post,
               status: :published,
               publish_scheduled_at: 1.hour.ago,
               user: user)
      end

      it 'does not modify the post' do
        expect { described_class.call(post) }
          .not_to(change { post.reload.updated_at })
      end
    end

    context 'when post is draft but publish_scheduled_at is not set' do
      let(:post) do
        create(:post,
               status: :draft,
               publish_scheduled_at: nil,
               user: user)
      end

      it 'does not publish the post' do
        described_class.call(post)
        expect(post.reload).to be_draft
        expect(post.published_at).to be_nil
      end
    end
  end
end
