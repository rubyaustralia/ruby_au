require "rails_helper"

describe ProfilesController do
  describe 'show' do
    let(:user) { FactoryBot.create(:user) }
    subject { get :show }

    it 'renders the profile page' do
      sign_in user
      subject
      expect(response).to render_template 'show'
    end
  end

  describe 'edit' do
    let(:user) { FactoryBot.create(:user) }
    subject { get :edit }

    it 'renders the edit profile page' do
      sign_in user
      subject
      expect(response).to render_template 'edit'
    end
  end

  describe 'update' do
    let(:user) { FactoryBot.create(:user) }
    subject { put :update, params: { user: user_param } }

    context 'valid request' do
      let(:user_param) do
        {
          email: 'totally.random@email.com',
          full_name: 'Bruce Wayne',
          preferred_name: 'Batman',
          mailing_list: 'true',
          visible: 'false',
        }
      end
      it 'updates the user and redirects to profile page' do
        sign_in user
        subject
        expect(user.reload.email).to eq 'totally.random@email.com'
        expect(response).to redirect_to profile_path
      end
    end

    context 'invalid request' do
      let(:user_param) do
        {
          email: 'totally.random@email',
        }
      end
      it 'renders the edit page' do
        sign_in user
        subject
        expect(user.reload.email).to_not eq 'totally.random@email'
        expect(response).to render_template 'edit'
      end
    end
  end
end
