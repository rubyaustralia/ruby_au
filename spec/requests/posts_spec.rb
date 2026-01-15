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

  describe "GET /feed" do
    let(:draft_posts) { create_list(:post, 3, :draft) }
    let(:news_posts) { create_list(:post, 6, :published, published_at: 2.days.ago, category: :news) }
    let(:announcement_posts) { create_list(:post, 6, :published, published_at: 1.day.ago, category: :announcements) }

    before do
      draft_posts
      news_posts
      announcement_posts
      get "/posts/feed.rss"
    end

    it "returns http success" do
      expect(response).to be_successful
    end

    it "returns RSS content type" do
      expect(response.content_type).to eq("application/rss+xml; charset=utf-8")
    end

    it "renders without layout" do
      expect(response).to render_template(layout: false)
    end

    it "renders the feed template" do
      expect(response).to render_template("posts/feed")
    end

    it "only shows published posts" do
      expect(assigns(:posts)).to include(*announcement_posts)
      expect(assigns(:posts)).not_to include(*draft_posts)
    end

    it "includes post metadata for each item" do
      published_posts = news_posts + announcement_posts

      published_posts.each do |post|
        expect(response.body).to include("<title>#{post.title}</title>")
        expect(response.body).to include("<link>#{post_url(post)}</link>")
        expect(response.body).to include("<guid>#{post_url(post)}</guid>")
      end
    end

    it "includes publication dates in RFC822 format" do
      news_posts.each do |post|
        expected_date = post.published_at.rfc822
        expect(response.body).to include("<pubDate>#{expected_date}</pubDate>")
      end
    end

    it "includes post categories" do
      expect(response.body).to include("<category>News</category>")
      expect(response.body).to include("<category>Announcements</category>")
    end

    context "with special characters" do
      before do
        create(:post, :published,
               content: "Content with <span>tags</span> & quotes \"test\"",
               published_at: 1.day.ago)

        get "/posts/feed.rss"
      end

      it "includes correctly escaped content" do
        expect(response.body).to include("Content with &lt;span&gt;tags&lt;/span&gt; &amp;amp; quotes \"test\"")
      end

      it "produces valid XML" do
        # Check that XML can be parsed without errors
        expect { Nokogiri::XML(response.body, &:strict) }.not_to raise_error
      end
    end
  end
end
