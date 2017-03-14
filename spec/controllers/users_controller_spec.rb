require 'rails_helper'

describe UsersController do
  render_views

  describe 'on GET to /users/new' do
    before { get :new }

    it "responds with success and renders the correct template" do
      expect(response).to be_success
      expect(response).to render_template 'users/new'
    end
  end

  describe 'on POST to /users/create' do

    it 'requires `joining_member` to be present in the params' do
      expect { post :create, params: {} }.to raise_error ActionController::ParameterMissing, 'param is missing or the value is empty: joining_member'
    end

    context 'valid parameters are supplied' do
      before { post :create,
               params: {
                 joining_member: { email: 'test@example.com', password: 'ThisIsAPassw0rd!', full_name: 'Barry Smith', preferred_name: 'Barry', mailing_list: true }
               }
             }

      it 'creates a valid user' do
        expect(assigns(:joining_member)).to be_valid
      end

      it 'signs the user in' do
       expect(request.env[:clearance].signed_in?).to be true
      end

      it 'redirects to just_joined_path' do
        expect(response).to redirect_to just_joined_path
      end
    end

    context 'insufficient parameters are supplied' do
      before { post :create, params: { joining_member: { password: '123'} } }

      it 'renders the `users/new` template' do
        expect(response).to render_template 'users/new'
      end
    end

  end
end
