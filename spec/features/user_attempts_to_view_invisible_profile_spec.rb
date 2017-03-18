require "rails_helper"
require "support/features/clearance_helpers"
require "support/factory_girl"

RSpec.describe "user attempts to view invisible profile" do
  scenario "returns a 404 page" do
    user = FactoryGirl.create(:user)
    invisible_profile = FactoryGirl.create(:profile)
    sign_in_with(user.email, user.password)

    expect {
      visit user_path(invisible_profile.user)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
