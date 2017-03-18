require "rails_helper"

RSpec.describe Profile, type: :model do
  it "is valid with valid attributes" do
    profile = Profile.new(user: User.new)
    expect(profile).to be_valid
  end

  it "is not valid without a user" do
    profile = Profile.new(user_id: nil)
    expect(profile).to_not be_valid
  end

  describe ".visible_for_user" do
    it "returns the matching users profile or visible profiles" do
      current_user = FactoryGirl.create(:user)
      current_user_profile = FactoryGirl.create(:profile, user: current_user)

      visible_profiles = create_list(:profile, 2, :visible)
      invisible_profiles = create_list(:profile, 2)

      expect(Profile.visible_for_user(current_user)).to match_array([*visible_profiles, current_user_profile])
    end
  end
end
