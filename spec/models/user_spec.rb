require 'rails_helper'

RSpec.describe User, type: :model do
  let(:unconfirmed_user) { create(:user, confirmed_at: nil) }
  let(:committee_user) { create(:user, committee: true) }
  let(:user) { create(:user) }

  describe '.committee' do
    before do
      committee_user
      unconfirmed_user
    end
    it 'returns users who are part of the committee' do
      expect(User.committee).to include(committee_user)
      expect(User.committee).not_to include(unconfirmed_user)
    end
  end

  describe '#emails' do
    it 'can have multiple emails' do
      user.emails.create!(email: 'test1@example.com')
      user.emails.create!(email: 'test2@example.com')
      expect(user.emails.count).to eq(3)
    end
  end

  describe '#active_for_authentication?' do
    it 'returns true if the user is not deactivated' do
      expect(user.active_for_authentication?).to be_truthy
    end

    it 'returns false if the user is deactivated' do
      user.deactivated_at = Time.current
      expect(user.active_for_authentication?).to be_falsey
    end
  end

  describe '#deactivated?' do
    it 'returns false if the user is not deactivated' do
      expect(user.deactivated?).to be_falsey
    end

    it 'returns true if the user is deactivated' do
      user.deactivated_at = Time.current
      expect(user.deactivated?).to be_truthy
    end
  end

  describe '.without_emails' do
    let(:user_with_email_field) do
      create(:user).tap do |user|
        user[:email] = user.email
        user.save!
        user.emails.destroy_all
      end
    end
    let(:user_with_emails_association) { create(:user) }

    it 'does not return users with email and associated Email record' do
      user_with_email_field
      user_with_emails_association
      expect(User.without_emails).to eq([user_with_email_field])
    end
  end

  describe '#update_emails' do
    let(:user_with_email_field) do
      create(:user, email: 'hello@world.com').tap do |user|
        user[:email] = user.email
        user.save!
        user.emails.destroy_all
      end
    end
    let(:user_with_emails_association) { create(:user) }

    it 'creates a new Email record for users with email but no associated Email record' do
      user_with_email_field

      expect { user_with_email_field.update_emails }.to change(Email, :count).by(1)
      expect(user_with_email_field.reload.read_attribute_before_type_cast('email')).to eq('hello@world.com')
      expect(user_with_email_field.emails.first).to have_attributes(
        email: 'hello@world.com',
        primary: true,
      )
    end

    it 'does not create a new Email record for users with email and associated Email record' do
      user_with_emails_association
      expect { user_with_emails_association.update_emails }.not_to change(Email, :count)
    end
  end
end
