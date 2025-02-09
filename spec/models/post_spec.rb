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
