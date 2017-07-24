require "rails_helper"

RSpec.describe "user attempts to view invisible profile" do
  scenario "returns a 404 page" do
    user = FactoryGirl.create(:user)
    invisible_user = FactoryGirl.create(:user)
    login_as user

    expect {
      visit user_path(invisible_user)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
