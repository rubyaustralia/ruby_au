require 'rails_helper'

RSpec.describe 'Admin::PostsController', type: :request do
  let(:admin) { create(:user, :committee) }
  let(:post_attributes) { attributes_for(:post) }

  before do
    sign_in admin
  end

  describe 'GET /admin/posts' do
    it 'displays posts in correct order' do
      published_post = create(:post, published_at: 1.day.ago)
      scheduled_post = create(:post, publish_scheduled_at: 1.day.from_now)
      regular_post = create(:post)

      get admin_posts_path
      expect(response).to have_http_status(:ok)

      posts = assigns(:posts)
      expect(posts.to_a).to eq([scheduled_post, published_post, regular_post])
    end

    it 'paginates the results' do
      create_list(:post, 30)
      get admin_posts_path
      expect(assigns(:posts).size).to be <= 25 # default page size
    end
  end

  describe 'GET /admin/posts/:id' do
    let(:post) { create(:post) }

    it 'shows the post' do
      get admin_post_path(post)
      expect(response).to have_http_status(:ok)
      expect(assigns(:post)).to eq(post)
    end

    it 'finds post by friendly id' do
      get admin_post_path(post.slug)
      expect(response).to have_http_status(:ok)
      expect(assigns(:post)).to eq(post)
    end

    it 'redirects to index when post not found' do
      get admin_post_path('non-existent')
      expect(response).to redirect_to(admin_posts_path)
    end
  end

  describe 'GET /admin/posts/new' do
    it 'initializes a new post' do
      get new_admin_post_path
      expect(response).to have_http_status(:ok)
      expect(assigns(:post)).to be_a_new(Post)
    end
  end

  describe 'GET /admin/posts/:id/edit' do
    let(:post) { create(:post) }

    it 'shows edit form' do
      get admin_edit_post_path(post)
      expect(response).to have_http_status(:ok)
      expect(assigns(:post)).to eq(post)
    end

    context 'when post is not editable' do
      let(:post) { create(:post, published_at: 1.day.ago) }

      it 'redirects with alert' do
        allow_any_instance_of(Post).to receive(:editable?).and_return(false)
        get admin_edit_post_path(post)
        expect(response).to redirect_to(admin_post_path(post))
        expect(flash[:alert]).to eq('Post can only be edited before scheduled.')
      end
    end
  end

  describe 'POST /admin/posts' do
    context 'with valid parameters' do
      it 'creates a new post' do
        expect do
          post admin_posts_path, params: { post: post_attributes }
        end.to change(Post, :count).by(1)

        expect(response).to redirect_to(admin_post_path(Post.last))
        expect(flash[:notice]).to eq('Post was successfully created.')
        expect(Post.last.user).to eq(admin)
      end

      it 'calls the publisher service' do
        expect(Posts::Publisher).to receive(:call)
        post admin_posts_path, params: { post: post_attributes }
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { post_attributes.merge(title: '') }

      it 'does not create a post' do
        expect do
          post admin_posts_path, params: { post: invalid_attributes }
        end.not_to change(Post, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'PATCH /admin/posts/:id' do
    let(:post) { create(:post) }
    let(:new_attributes) { { title: 'Updated Title' } }

    context 'with valid parameters' do
      it 'updates the post' do
        patch admin_post_path(post), params: { post: new_attributes }

        post.reload
        expect(post.title).to eq('Updated Title')
        expect(response).to redirect_to(admin_post_path(post))
        expect(flash[:notice]).to eq('Post was successfully updated.')
      end

      it 'calls the publisher service' do
        expect(Posts::Publisher).to receive(:call)
        patch admin_post_path(post), params: { post: new_attributes }
      end
    end

    context 'with invalid parameters' do
      let(:invalid_attributes) { { title: '' } }

      it 'does not update the post' do
        original_title = post.title
        patch admin_post_path(post), params: { post: invalid_attributes }

        post.reload
        expect(post.title).to eq(original_title)
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response).to render_template(:edit)
      end
    end

    context 'when post is not editable' do
      before do
        allow_any_instance_of(Post).to receive(:editable?).and_return(false)
      end

      it 'redirects without updating' do
        patch admin_post_path(post), params: { post: new_attributes }
        expect(response).to redirect_to(admin_post_path(post))
        expect(flash[:alert]).to eq('Post can only be edited before scheduled.')
      end
    end
  end

  context 'when not authenticated' do
    before { sign_out admin }

    it 'redirects to sign in' do
      get admin_posts_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
