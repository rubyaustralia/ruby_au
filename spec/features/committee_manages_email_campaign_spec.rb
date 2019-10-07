# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Committee manages email campaigns", type: :feature do
  let(:user) { FactoryBot.create(:user, committee: true) }

  before :each do
    log_in_as user
  end

  scenario "create a new stand-alone campaign" do
    FactoryBot.create(:user, full_name: "Alex", email: "alex@ruby.test")

    click_link "Campaigns"
    click_link "Add"

    fill_in "Subject", with: "Random News"
    fill_in "Pre-Header", with: "Please read me"
    fill_in "Content", with: "Here's the latest from Ruby Australia"
    click_button "Save"

    Campaigns::Send.call Campaign.first

    self.current_email = emails_sent_to("alex@ruby.test").detect do |mail|
      mail.subject == "Random News"
    end
    expect(current_email).to be_present

    click_link "Campaigns"
    expect(page).to have_content("Random News")
    expect(page).to_not have_content("Edit")
    expect(page).to_not have_content("Delete")
  end

  scenario "editing a campaign" do
    FactoryBot.create(:campaign, subject: "Latest News")

    click_link "Campaigns"
    click_link "Edit"

    fill_in "Subject", with: "Random News"
    click_button "Save"

    expect(page).to have_content("Random News")
    expect(page).to_not have_content("Latest News")
  end

  scenario "deleting a campaign" do
    FactoryBot.create(:campaign, subject: "Latest News")

    click_link "Campaigns"
    click_link "Delete"

    expect(page).to have_content("Your campaign has been deleted.")
    expect(page).to_not have_content("Latest News")
  end
end
