require 'rails_helper'

RSpec.describe 'Admin::Dashboard', type: :request do
  let(:admin) { create(:user, :committee) }

  before do
    sign_in admin
  end

  describe 'GET /admin/dashboard' do
    context 'when searching for users' do
      let!(:user) { create(:user, full_name: 'Nick Wolf', email: 'nick@example.com') }

      it 'finds users by name' do
        get admin_dashboard_path, params: { users_search: 'Nick' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:users_for_management)).to include(user)
      end

      it 'finds users by email' do
        get admin_dashboard_path, params: { users_search: 'nick@example.com' }
        expect(response).to have_http_status(:ok)
        expect(assigns(:users_for_management)).to include(user)
      end
    end
  end
end
