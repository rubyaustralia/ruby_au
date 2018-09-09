require "rails_helper"

describe UsersController do
  describe 'new' do
    subject { get :new }

    it 'renders the new user page' do
      subject
      expect(response).to render_template 'new'
    end
  end

  describe 'create' do
    subject { post :create, params: { user: user_params } }

    context 'valid params' do
      let(:user_params) do
        {
          full_name: 'Bruce Wayne',
          preferred_name: 'Batman',
          email: 'bruce@wayne.com',
          password: 'iambatman',
        }
      end

      it 'saves the user and redirects to profile page' do
        expect(request.env['warden']).to receive(:set_user)
        subject
        user = User.find_by(email: 'bruce@wayne.com')
        expect(user).to_not be_nil
        expect(response).to redirect_to user_path(user)
      end
    end

    context 'invalid params' do
      let(:user_params) do
        {
          password: 'iambatman',
        }
      end

      it 'does not save the user and render new user page' do
        subject
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'show' do
    let(:user) { FactoryBot.create(:user) }
    subject { get :show, params: { id: user.id } }

    it 'renders the user profile page' do
      sign_in user
      subject
      expect(response).to render_template 'show'
    end
  end
end
