require "rails_helper"

describe PasswordsController do
  describe 'new' do
    before { get :new }

    it 'renders the new password page' do
      expect(response).to render_template 'new'
    end
  end

  describe 'create' do
    subject { post :create, params: { change_password: { email: email } } }

    context 'when user exists' do
      let(:user) { FactoryGirl.create(:user) }
      let(:email) { user.email }

      it 'sends a change password email to the user' do
        expect { subject }
          .to change { ActionMailer::Base.deliveries.count }.by(1)

        mail = ActionMailer::Base.deliveries.last
        expect(mail.subject).to match(/Change your password/)
      end
    end

    context 'when user does not exists' do
      let(:email) { 'some.random@email' }

      it 'does nothing' do
        expect { subject }
          .to_not(change { ActionMailer::Base.deliveries.count })
      end
    end
  end

  describe 'update' do
    let(:user) { FactoryGirl.create(:user) }
    subject { put :update, params: { change_password: { password: password } } }

    context 'when password is valid' do
      let(:password) { 'new_password' }
      it 'updates the password and redirects to profile page' do
        sign_in user
        expect { subject }.to(change { user.password })
        expect(response).to redirect_to profile_path
      end
    end

    context 'when password is nil' do
      let(:password) { nil }
      it 'does not update the password' do
        sign_in user
        expect { subject }.to_not(change { user.password })
      end
    end
  end
end
