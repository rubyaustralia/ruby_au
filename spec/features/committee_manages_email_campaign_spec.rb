# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Committee manages email campaigns", type: :feature do
  let(:user) { FactoryBot.create(:user, committee: true) }

  before do
    log_in_as user

    clear_emails
  end

  scenario "create a new stand-alone campaign" do
    FactoryBot.create(:user, full_name: "Alex", email: "alex@ruby.test")

    click_link "Campaigns"
    click_link "New Campaign"

    fill_in "Subject", with: "Random News"
    fill_in "Preheader", with: "Please read me"
    fill_in "Content", with: "Here's the latest from Ruby Australia"
    click_button "Save"

    Campaigns::Send.call Campaign.first

    self.current_email = emails_sent_to("alex@ruby.test").detect do |mail|
      mail.subject == "Random News"
    end
    expect(current_email).to be_present

    click_link "Campaigns"
    expect(page).to have_content("Random News")
    expect(page).not_to have_content("Edit")
    expect(page).not_to have_content("Delete")
  end

  scenario "create a new campaign with an event" do
    FactoryBot.create(:user, full_name: "Alex", email: "alex@ruby.test")
    FactoryBot.create(:rsvp_event, title: "AGM")

    click_link "Campaigns"
    click_link "New Campaign"

    select "AGM", from: "Event"
    fill_in "Subject", with: "Random News"
    fill_in "Preheader", with: "Please read me"
    fill_in "Content", with: "Can you make it?\n\n{{ rsvp_links }}"
    click_button "Save"

    Campaigns::Send.call Campaign.first

    self.current_email = emails_sent_to("alex@ruby.test").detect do |mail|
      mail.subject == "Random News"
    end
    expect(current_email).to be_present

    current_email.click_link "Yes"
    expect(page).to have_content("Thanks for confirming your attendance")
  end

  # scenario "editing a campaign" do
  #   FactoryBot.create(:campaign, subject: "Latest News")
  #
  #   click_link "Campaigns"
  #   click_link "Edit"
  #
  #   fill_in "Subject", with: "Random News"
  #   click_button "Save"
  #
  #   expect(page).to have_content("Random News")
  #   expect(page).to_not have_content("Latest News")
  # end

  scenario "deleting a campaign" do
    FactoryBot.create(:campaign, subject: "Latest News")

    click_link "Campaigns"
    click_link "Delete"

    expect(page).to have_content("Your campaign has been deleted.")
    expect(page).not_to have_content("Latest News")
  end

  scenario "sending campaigns" do
    user = FactoryBot.create(:user, email: "alex@ruby.test")
    campaign = FactoryBot.create(:campaign)

    Campaigns::Send.call campaign
    Campaigns::Send.call campaign

    emails = emails_sent_to(user.email).select do |mail|
      mail.subject == campaign.subject
    end

    expect(emails.length).to eq(1)
  end
end
