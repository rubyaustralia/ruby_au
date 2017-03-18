require "rails_helper"
require "rails_helper"
require "support/features/clearance_helpers"
require "support/factory_girl"

RSpec.describe "User edits profile details" do
  scenario "by filling in the form" do
    user = FactoryGirl.create(:user, email: 'littlebunnyfoofoo@gmail.com')
    FactoryGirl.create(:profile, user: user)
    new_email = 'bigbunnyfoofoo@gmail.com'
    sign_in_with(user.email, user.password)

    fill_in "member_email", with: new_email
    fill_in "member_preferred_name", with: "Big Bunny"
    find(:css, "#member_visible").set(true)


    click_button I18n.t("helpers.submit.editing_member.update")

    expect(page).to have_content I18n.t("users.update.notice")

    expect(user.reload.profile.reload.preferred_name).to eq("Big Bunny")
    expect(user.reload.profile.reload.visible).to be_truthy
  end
end
