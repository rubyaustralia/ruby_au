require "rails_helper"

RSpec.feature "User deactivates their membership", type: :feature do
  let(:user) { create :user }

  scenario "through their details page" do
    expect(user.memberships.current.count).to eq(1)

    log_in_as user
    visit my_details_path

    click_button "Resign from Ruby Australia"
    expect(page).to have_content(
      "Your membership to Ruby Australia has ceased."
    )

    user.reload
    expect(user.memberships.current.count).to be_zero

    visit new_user_session_path

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Log in"

    expect(page).to_not have_content("Signed in successfully")
  end
end
