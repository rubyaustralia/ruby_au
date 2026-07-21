require 'rails_helper'

RSpec.describe 'Admin::Users', type: :request do
  let(:admin) { create(:user, :committee) }

  before do
    sign_in admin
  end

  describe 'GET /admin/users/search' do
    before do
      create(:user, full_name: 'Nicholas Wolf', preferred_name: 'Nick', email: 'nick@example.com')
    end

    it 'finds users by name and returns JSON' do
      get search_admin_users_path, params: { q: 'Nick' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first['name']).to eq('Nicholas Wolf')
      expect(json.first['email']).to eq('nick@example.com')
    end

    it 'finds users by email and returns JSON' do
      get search_admin_users_path, params: { q: 'nick@example.com' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json.first['name']).to eq('Nicholas Wolf')
      expect(json.first['email']).to eq('nick@example.com')
    end

    it 'requires at least 2 characters' do
      get search_admin_users_path, params: { q: 'N' }
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json).to be_empty
    end
  end
end
