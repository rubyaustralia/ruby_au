require "rails_helper"

RSpec.feature "User reactivates their membership", type: :feature do
  let(:user) { create :user, :deactivated }

  scenario "with their credentials" do
    expect(user.memberships.count).to eq(1)
    expect(user.memberships.current.count).to eq(0)

    visit new_user_session_path

    click_link "Reactivate Membership"

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Reactivate"

    expect(page).to have_content("Your membership to Ruby Australia has been reactivated.")
    expect(page).to have_content("Log out")

    user.reload
    expect(user.memberships.current.count).to eq(1)
  end

  scenario "with invalid credentials" do
    expect(user.memberships.count).to eq(1)
    expect(user.memberships.current.count).to eq(0)

    visit new_user_session_path

    click_link "Reactivate Membership"

    fill_in "Email",    with: user.email
    fill_in "Password", with: "not-the-password"
    click_button "Reactivate"

    expect(page).to have_content("The provided details are not valid.")

    user.reload
    expect(user.memberships.current.count).to eq(0)
  end

  scenario "with valid credentials for an active account" do
    user = create :user

    expect(user.memberships.count).to eq(1)
    expect(user.memberships.current.count).to eq(1)

    visit new_user_session_path

    click_link "Reactivate Membership"

    fill_in "Email",    with: user.email
    fill_in "Password", with: user.password
    click_button "Reactivate"

    expect(page).to have_content("The provided details are not valid.")

    user.reload
    expect(user.memberships.count).to eq(1)
    expect(user.memberships.current.count).to eq(1)
  end
end
