require "rails_helper"

RSpec.describe "user attempts to view invisible profile" do
  scenario "returns a 404 page" do
    user = FactoryBot.create(:user)
    invisible_user = FactoryBot.create(:user)
    login_as user

    expect {
      visit user_path(invisible_user)
    }.to raise_error(ActiveRecord::RecordNotFound)
  end
end
