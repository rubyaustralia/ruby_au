require 'rails_helper'

RSpec.describe 'Admin::ElectionsController', type: :request do
  let(:admin) { create(:user, :committee) }
  let(:valid_attributes) do
    {
      title: 'President',
      vacancies: '1',
      point_scale: '2',
      opened_at: '',
      closed_at: '2026-05-16T20:39'
    }
  end

  before do
    sign_in admin
  end

  describe 'POST /admin/elections' do
    context 'with valid parameters' do
      it 'creates a new Election' do
        expect do
          post admin_elections_path, params: { election: valid_attributes }
        end.to change(Election, :count).by(1)

        expect(response).to redirect_to(admin_election_path(Election.last))
        expect(flash[:notice]).to eq('Election was successfully created.')

        election = Election.last
        expect(election.title).to eq('President')
        expect(election.point_scale).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Election' do
        expect do
          post admin_elections_path, params: { election: valid_attributes.merge(title: '') }
        end.not_to change(Election, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end
end
