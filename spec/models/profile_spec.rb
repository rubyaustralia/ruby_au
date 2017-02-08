require 'rails_helper'

RSpec.describe Profile, type: :model do
  it "is valid with valid attributes" do
    profile = Profile.new(user: User.new)
    expect(profile).to be_valid
  end

  it "is not valid without a user" do
    profile = Profile.new(user_id: nil)
    expect(profile).to_not be_valid
  end
end
