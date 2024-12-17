require 'rails_helper'

RSpec.describe Email, type: :model do
  subject(:email) { build(:email) }

  describe 'associations' do
    it 'belongs to a user' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'validations' do
    context 'presence' do
      it 'requires an email address' do
        email.email = nil
        expect(email).not_to be_valid
        expect(email.errors[:email]).to include("can't be blank")
      end

      it 'requires a user' do
        email.user = nil
        expect(email).not_to be_valid
        expect(email.errors[:user]).to include("must exist")
      end
    end

    context 'uniqueness' do
      it 'requires a unique email address regardless of case' do
        existing_email = create(:email, email: 'TEST@example.com')
        new_email = build(:email, email: 'test@example.com')

        expect(new_email).not_to be_valid
        expect(new_email.errors[:email]).to include('has already been taken')
      end
    end

    context 'format' do
      it 'accepts valid email addresses' do
        valid_emails = ['user@example.com', 'user.name@example.co.uk', 'user+label@example.com']

        valid_emails.each do |valid_email|
          email.email = valid_email
          expect(email).to be_valid
        end
      end

      it 'rejects invalid email addresses' do
        invalid_emails = ['invalid_email', 'user@', '@example.com']

        invalid_emails.each do |invalid_email|
          email.email = invalid_email
          expect(email).to be_invalid
          expect(email.errors[:email]).to be_present
        end
      end
    end
  end
end
