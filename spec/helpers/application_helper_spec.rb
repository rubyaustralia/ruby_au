require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#password_errors?' do
    it 'detects password errors without relying on the removed errors keys API' do
      user = User.new
      user.errors.add(:password, :blank)

      expect(user.errors).not_to respond_to(:keys)
      expect(helper.password_errors?(user)).to be(true)
    end

    it 'does not detect unrelated errors as password errors' do
      user = User.new
      user.errors.add(:full_name, :blank)

      expect(helper.password_errors?(user)).to be(false)
    end
  end
end
