# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Admin campaign UI flows", type: :feature do
  let(:admin) { FactoryBot.create(:user, committee: true) }
  let!(:membership) { FactoryBot.create(:membership, user: admin) }
  let!(:campaign) { FactoryBot.create(:campaign, subject: "Test Campaign") }

  before do
    log_in_as admin
    clear_emails
  end

  scenario "sending a test email" do
    membership # Ensure membership exists
    visit edit_admin_campaign_path(campaign)
    click_button "Send Test Email"

    expect(page).to have_content("A test email has been sent to #{admin.email}.")
    expect(emails_sent_to(admin.email).count).to eq(1)
  end

  scenario "delivering a campaign enqueues a job" do
    visit edit_admin_campaign_path(campaign)

    expect do
      click_button "Send Campaign Now"
    end.to have_enqueued_job(Campaigns::DeliverJob).with(campaign)

    expect(page).to have_content("The campaign is being sent.")
  end

  scenario "viewing recipients" do
    membership # Ensure membership exists
    visit edit_admin_campaign_path(campaign)
    click_link "View Recipients"

    expect(page).to have_content("Recipients")
    expect(page).to have_content(admin.full_name)
    expect(page).to have_content(admin.email)
  end
end
