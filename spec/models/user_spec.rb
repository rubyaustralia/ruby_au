# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  address                :text
#  committee              :boolean          default(FALSE), not null
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  deactivated_at         :datetime
#  email                  :string
#  email_confirmed        :boolean          default(FALSE)
#  encrypted_password     :string
#  full_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  linkedin_url           :string
#  mailing_list           :boolean          default(FALSE), not null
#  mailing_lists          :json             not null
#  preferred_name         :string
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  seeking_work           :boolean          default(FALSE), not null
#  sign_in_count          :integer          default(0), not null
#  token                  :string
#  unconfirmed_email      :string
#  visible                :boolean          default(FALSE), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
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
      expect(described_class.committee).to include(committee_user)
      expect(described_class.committee).not_to include(unconfirmed_user)
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
      expect(user).to be_active_for_authentication
    end

    it 'returns false if the user is deactivated' do
      user.deactivated_at = Time.current
      expect(user).not_to be_active_for_authentication
    end
  end

  describe '#deactivated?' do
    it 'returns false if the user is not deactivated' do
      expect(user).not_to be_deactivated
    end

    it 'returns true if the user is deactivated' do
      user.deactivated_at = Time.current
      expect(user).to be_deactivated
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
      expect(described_class.without_emails).to eq([user_with_email_field])
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

    it 'does not trigger update_mailing_list_and_memberships method' do
      allow(user_with_email_field).to receive(:update_mailing_list_and_memberships)
      expect(user_with_email_field).not_to have_received(:update_mailing_list_and_memberships)
      user_with_email_field.update_emails
    end

    it 'does not create a new Email record for users with email and associated Email record' do
      user_with_emails_association
      expect { user_with_emails_association.update_emails }.not_to change(Email, :count)
    end
  end
end
