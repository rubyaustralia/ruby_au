require "rails_helper"
require "tempfile"
require "csv"

RSpec.describe "Committee importing members", type: :feature do
  let(:user) { FactoryBot.create(:user, committee: true) }

  before do
    log_in_as user
  end

  scenario "via CSV file" do
    output = CSV.generate do |csv|
      csv << %w[name email]
      csv << ["Alex", "alex@ruby.test"]
      csv << ["Jules", "jules@ruby.test"]
      csv << ["Riley", "riley@ruby.test"]
      csv << ["Lindsay", "lindsay@ruby.test"]
    end

    FactoryBot.create(:user, email: "lindsay@ruby.test")
    jules = FactoryBot.create(:user, email: "jules@ruby.test")
    jules.memberships.current.update left_at: 1.minute.ago

    camp = Tempfile.new("camp")
    camp.write output
    camp.rewind

    click_link "Imported Members"

    fill_in "Source", with: "Rails Camp"
    attach_file "CSV File", camp.path
    click_button "Upload"

    expect(page).to have_content("Alex")
    expect(page).to have_content("Riley")
    expect(page).to_not have_content("Jules")
    expect(page).to_not have_content("Lindsay")

    camp.close

    output = CSV.generate do |csv|
      csv << %w[name email]
      csv << ["Riley", "riley@ruby.test"]
      csv << ["Dylan", "dylan@ruby.test"]
    end
    conf = Tempfile.new("conf")
    conf.write output
    conf.rewind

    fill_in "Source", with: "RubyConf AU"
    attach_file "CSV File", conf.path
    click_button "Upload"

    expect(page).to have_content("Riley", count: 1)
    expect(page).to have_content("Dylan")

    conf.close
  end
end
