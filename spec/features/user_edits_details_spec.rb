require "rails_helper"
require "support/features/clearance_helpers"
require "support/factory_girl"

RSpec.describe "User edits profile details" do
  scenario "by filling in the form" do
    user = create(:user, email: 'littlebunnyfoofoo@gmail.com')
    create(:profile, user: user)
    new_email = 'bigbunnyfoofoo@gmail.com'
    sign_in_with(user.email, user.password)

    fill_in "editing_member_email", with: new_email

    click_button I18n.t("helpers.submit.editing_member.update")

    expect(page).to have_content I18n.t("users.update.notice")
  end
end
