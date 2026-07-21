require 'rails_helper'

RSpec.describe 'Admin::Memberships', type: :request do
  let(:admin) { create(:user, :committee) }

  before do
    sign_in admin
  end

  describe 'GET /admin/memberships' do
    let!(:user) { create(:user, full_name: 'Alex Member', preferred_name: 'Al') }

    before do
      create(:email, :confirmed, user: user, email: 'alex@example.com', primary: true)
      # Ensure membership exists if it wasn't created automatically
      user.memberships.create!(joined_at: Time.current) if user.memberships.none?
    end

    it 'finds members by full name' do
      get admin_memberships_path, params: { q: 'Alex' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Alex Member')
    end

    it 'finds members by preferred name' do
      get admin_memberships_path, params: { q: 'Al' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Alex Member')
    end

    it 'finds members by email' do
      get admin_memberships_path, params: { q: 'alex@example.com' }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Alex Member')
    end

    it 'does not find members who do not match' do
      get admin_memberships_path, params: { q: 'Nonexistent' }
      expect(response).to have_http_status(:ok)
      expect(response.body).not_to include('Alex Member')
    end
  end
end
