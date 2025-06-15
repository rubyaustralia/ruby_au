require 'rails_helper'

RSpec.describe "/posts", type: :request do
  describe "GET /index" do
    let(:draft_posts) { create_list(:post, 3, :draft) }
    let(:news_posts) { create_list(:post, 6, :published, published_at: 2.days.ago, category: :news) }
    let(:announcement_posts) { create_list(:post, 6, :published, published_at: 1.day.ago, category: :announcements) }

    before do
      draft_posts
      news_posts
      announcement_posts
    end

    it "returns http success" do
      get posts_path
      expect(response).to be_successful
    end

    it "only shows published posts" do
      get posts_path
      expect(assigns(:posts)).to include(*announcement_posts)
      expect(assigns(:posts)).not_to include(draft_posts)
    end

    context "with category filter" do
      it "filters posts by category" do
        get posts_path(category: "announcements")
        expect(assigns(:posts)).to include(*announcement_posts)
        expect(assigns(:posts)).not_to include(*news_posts)
      end
    end
  end

  describe "GET /show" do
    let(:post) { create(:post, :published, title: "Test Post") }

    before do
      post
    end

    context "with a valid slug" do
      it "returns http success" do
        get post_path(post.slug)
        expect(response).to be_successful
      end

      it "assigns the requested post" do
        get post_path(post.slug)
        expect(assigns(:post)).to eq(post)
      end
    end

    context "with an invalid slug" do
      before do
        get post_path("invalid-slug")
      end

      it "redirects to the posts index page" do
        expect(response).to redirect_to(posts_path)
      end

      it "displays an appropriate error message" do
        expect(flash[:error]).to eq("Post 'invalid-slug' is not found")
      end
    end
  end
end
