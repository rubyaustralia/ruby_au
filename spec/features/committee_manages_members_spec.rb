require "rails_helper"

RSpec.describe "Committee managing members", type: :feature do
  let(:user) { FactoryBot.create(:user, committee: true) }

  before do
    log_in_as user
  end

  scenario "views the list of current members" do
    FactoryBot.create(:user, full_name: "Alex")
    FactoryBot.create(:user, :invisible, full_name: "Dylan")
    FactoryBot.create(:user, full_name: "Jules", confirmed_at: nil)
    riley = FactoryBot.create(:user, full_name: "Riley")

    visit root_path
    click_link "Members"
    expect(page).to have_content "Alex"
    expect(page).to_not have_content "Dylan"
    expect(page).to_not have_content "Jules"
    expect(page).to have_content "Riley"

    riley.memberships.current.update left_at: 1.minute.ago

    click_link "Members"
    expect(page).to have_content "Alex"
    expect(page).to_not have_content "Riley"
  end
end
