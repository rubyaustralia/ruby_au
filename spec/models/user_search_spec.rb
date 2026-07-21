require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.search' do
    let!(:user) { create(:user, full_name: 'Nicholas Wolf', preferred_name: 'Nick') }

    before do
      create(:email, user: user, email: 'nick.wolf@example.com', primary: true)
      create(:email, user: user, email: 'wolfy@example.org', primary: false)
    end

    it 'finds user by full name' do
      expect(described_class.search('Nicholas')).to include(user)
    end

    it 'finds user by preferred name' do
      expect(described_class.search('Nick')).to include(user)
    end

    it 'finds user by primary email' do
      expect(described_class.search('nick.wolf@example.com')).to include(user)
    end

    it 'finds user by secondary email' do
      expect(described_class.search('wolfy@example.org')).to include(user)
    end

    it 'finds user by partial email' do
      expect(described_class.search('wolfy')).to include(user)
    end

    it 'escapes wildcards' do
      user_with_underscore = create(:user, full_name: 'Nick_Wolf')
      expect(described_class.search('Nick_Wolf')).to include(user_with_underscore)
      expect(described_class.search('Nick_Wolf')).not_to include(user)
    end
  end
end
