require 'rails_helper'

RSpec.describe JoiningMember, type: :form do
  describe 'validations' do

    it 'is valid with all required attributes set' do
      form = JoiningMember.new(user: User.new)
      form.attributes = {
        email: 'text@example.com', password: 'password', full_name: 'bob name',
        preferred_name: 'bob', mailing_list: true
      }

      expect(form).to be_valid
    end

    it 'will not buile without a User' do
      form = -> { JoiningMember.new }
      expect(form).to raise_error(ArgumentError)
    end

    it 'creates a UserProfile' do
      user = User.new
      expect(user.profile).to be nil

      JoiningMember.new(user: user)
      expect(user.profile).to_not be nil
    end

    it 'persists the User and UserProfile when saved' do
      form_attrs = {
        email: 'test_persistence@example.com', password: 'password',
        full_name: 'test name', preferred_name: 'test', mailing_list: true
      }

      form = JoiningMember.new(user: User.new)
      form.attributes = form_attrs

      expect(form).to be_valid
      expect(form.save).to be true

      user = form.user
      expect(user).to be_persisted
      expect(user.email).to eq form_attrs.fetch(:email)

      profile = user.profile
      expect(profile).to be_persisted
      expect(profile.mailing_list).to eq form_attrs.fetch(:mailing_list)
    end
  end
end
