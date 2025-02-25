require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    let(:post) { build(:post, title: 'Test Title', content: 'Test Content', category: :news, user: user) }

    it 'is valid with valid attributes' do
      expect(post).to be_valid
    end

    it 'requires a title' do
      post.title = nil
      expect(post).not_to be_valid
      expect(post.errors[:title]).to include("can't be blank")
    end

    it 'requires content' do
      post.content = nil
      expect(post).not_to be_valid
      expect(post.errors[:content]).to include("can't be blank")
    end

    it 'requires a category' do
      post.category = nil
      expect(post).not_to be_valid
      expect(post.errors[:category]).to include("can't be blank")
    end

    it 'requires a user' do
      post.user = nil
      expect(post).not_to be_valid
      expect(post.errors[:user]).to include("must exist")
    end

    describe 'prevent_duplicated_slug validation' do
      let(:existing_post) { create(:post, title: 'Existing Title') }

      before do
        existing_post
      end

      it 'prevents duplicate slugs' do
        new_post = build(:post, title: 'Existing Title')
        expect(new_post).not_to be_valid
        expect(new_post.errors[:slug]).to include('is already taken')
      end

      it 'prevents duplicate slugs with different casing' do
        new_post = build(:post, title: 'EXISTING TITLE')
        new_post.save
        expect(new_post).not_to be_valid
        expect(new_post.errors[:slug]).to include('is already taken')
      end

      it 'prevents duplicate slugs in dated format' do
        travel_to Time.zone.local(2024, 2, 8) do
          existing_post.update!(published_at: Time.current)
          new_post = build(:post, title: 'Existing Title', published_at: Time.current)
          expect(new_post).not_to be_valid
          expect(new_post.errors[:slug]).to include('is already taken')
        end
      end

      it 'allows same title for the same post (on update)' do
        existing_post.title = 'Existing Title'
        expect(existing_post).to be_valid
      end
    end
  end

  describe 'associations' do
    let(:post) { build(:post) }

    it 'belongs to a user' do
      expect(post.user).to be_present
    end
  end

  describe 'enums' do
    let(:post) { create(:post) }

    describe 'status' do
      it 'defines the correct statuses' do
        expect(Post.statuses).to eq({
                                      "draft" => 0,
                                      "scheduled" => 1,
                                      "published" => 2,
                                      "archived" => 3
                                    })
      end

      it 'defaults to draft' do
        expect(post.status).to eq("draft") # based on factory default
        new_post = Post.new
        expect(new_post.status).to eq("draft") # model default
      end
    end

    describe 'category' do
      it 'defines the correct categories' do
        expect(Post.categories).to eq({
                                        "news" => 0,
                                        "announcements" => 1
                                      })
      end
    end
  end

  describe 'scopes' do
    let(:user) { create(:user) }

    describe '.published_with_associations' do
      let(:published_post1) { create(:post, user: user, status: :published, published_at: 2.days.ago) }
      let(:published_post2) { create(:post, user: user, status: :published, published_at: 1.day.ago) }
      let(:draft_post) { create(:post, user: user, status: :draft) }

      before do
        published_post1
        published_post2
        draft_post
      end

      it 'returns only published posts in descending order' do
        expect(Post.published_with_associations).to eq([published_post2, published_post1])
      end
    end

    describe '.filter_by_category' do
      let(:news_post) { create(:post, user: user, category: :news) }
      let(:announcement_post) { create(:post, user: user, category: :announcements) }

      before do
        news_post
        announcement_post
      end
      it 'filters posts by category when category is provided' do
        results = Post.filter_by_category(:news)
        expect(results).to include(news_post)
        expect(results).not_to include(announcement_post)
      end

      it 'returns nil when category is not provided' do
        expect(Post.filter_by_category(nil)).to match_array([news_post, announcement_post])
      end
    end
  end

  describe '#publishable?' do
    let(:post) { build(:post) }

    it 'returns true when post is draft and has publish_scheduled_at' do
      post.status = :draft
      post.publish_scheduled_at = 1.day.from_now
      expect(post).to be_publishable
    end

    it 'returns false when post is not draft' do
      post.status = :published
      post.publish_scheduled_at = 1.day.from_now
      expect(post).not_to be_publishable
    end

    it 'returns false when post has no publish_scheduled_at' do
      post.status = :draft
      post.publish_scheduled_at = nil
      expect(post).not_to be_publishable
    end
  end

  describe '#editable?' do
    let(:post) { build(:post) }

    it 'returns true when post is draft and has no publish_scheduled_at' do
      post.status = :draft
      post.publish_scheduled_at = nil
      expect(post).to be_editable
    end

    it 'returns false when post is not draft' do
      post.status = :published
      post.publish_scheduled_at = nil
      expect(post).not_to be_editable
    end

    it 'returns false when post has publish_scheduled_at' do
      post.status = :draft
      post.publish_scheduled_at = 1.day.from_now
      expect(post).not_to be_editable
    end
  end

  describe '#publish!' do
    let(:post) { create(:post, status: :draft) }

    it 'updates status to published and sets published_at' do
      travel_to Time.zone.local(2024, 2, 8, 12, 0, 0) do
        post.publish!
        post.reload

        expect(post).to be_published
        expect(post.published_at).to be_within(0.001).of(Time.current)
      end
    end
  end

  describe 'slug generation' do
    let(:user) { create(:user) }

    context 'when published_at is not set' do
      it 'generates a slug from normalized title' do
        post = create(:post, title: 'Sample Blog Post Title!', user: user)
        expect(post.reload.slug).to eq('sample-blog-post-title')
      end
    end

    context 'when published_at is set' do
      it 'generates a slug with date and normalized title' do
        travel_to Time.zone.local(2024, 2, 8) do
          post = create(:post,
                        title: 'Sample Blog Post Title!',
                        published_at: Time.current,
                        user: user)

          expect(post.reload.slug).to eq('2024/2/8/sample-blog-post-title')
        end
      end
    end

    context 'with a very long title' do
      it 'limits slug to first 10 words' do
        post = create(:post,
                      title: 'This is a very long title that should be truncated to only ten words and the rest ignored',
                      user: user)
        expect(post.reload.slug).to eq('this-is-a-very-long-title-that-should-be-truncated')
      end
    end

    context 'when title has special characters' do
      it 'removes special characters and normalizes spacing' do
        post = create(:post,
                      title: 'Special @#$% Characters & Spaces!!!',
                      user: user)
        expect(post.reload.slug).to eq('special-characters-spaces')
      end
    end

    context 'when title or published_at changes' do
      let(:post) { create(:post, title: 'Original Title', user: user) }

      it 'generates new slug when title changes' do
        post.update!(title: 'New Title')
        expect(post.reload.slug).to eq('new-title')
      end

      it 'generates new slug when published_at changes' do
        travel_to Time.zone.local(2024, 2, 8) do
          post.update!(published_at: Time.current)
          expect(post.reload.slug).to eq('2024/2/8/original-title')
        end
      end
    end
  end
end
