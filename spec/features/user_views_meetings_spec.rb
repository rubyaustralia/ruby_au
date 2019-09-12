require "rails_helper"

RSpec.describe "User views upcoming meetings", type: :feature do
  let(:user) { create(:user) }
  let(:event) { create(:rsvp_event) }

  before do
    event

    log_in_as user
  end

  it "rsvp to a meeting" do
    click_link "Upcoming Meetings"
    click_link event.title
    click_link "confirm"

    expect(page).to have_content("Thanks for confirming your attendance")
  end
end
