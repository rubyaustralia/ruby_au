require "rails_helper"
require "tempfile"
require "csv"

RSpec.describe "Committee importing members", type: :feature do
  let(:user) { FactoryBot.create(:user, committee: true) }

  scenario "via CSV file" do
    log_in_as user

    output = CSV.generate do |csv|
      csv << %w[ticket_full_name ticket_email]
      csv << ["Alex", "alex@ruby.test"]
      csv << ["Jules", "jules@ruby.test"]
      csv << ["Riley", "riley@ruby.test"]
      csv << ["Lindsay", "lindsay@ruby.test"]
      csv << ["", "charlie@ruby.test"]
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
    expect(page).to have_content("charlie@ruby.test")
    expect(page).not_to have_content("Jules")
    expect(page).not_to have_content("Lindsay")

    camp.close

    output = CSV.generate do |csv|
      csv << %w[ticket_full_name ticket_email]
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

  context "when sending invitations" do
    before do
      clear_emails

      FactoryBot.create :imported_member, email: "riley@ruby.test"
      FactoryBot.create :imported_member, email: "dylan@ruby.test"
      FactoryBot.create(
        :imported_member, email: "charlie@ruby.test", full_name: ''
      )

      SendInvitations.call
    end

    scenario "accepts an invitation" do
      stub_request(
        :get, %r{https://api.createsend.com/api/v3.3/subscribers/.*\.json}
      ).and_return(
        body: JSON.dump("State" => "Active"),
        headers: { "Content-Type" => "application/json" }
      )

      self.current_email = emails_sent_to("riley@ruby.test").detect do |mail|
        mail.subject == "Ruby Australia Membership"
      end
      expect(current_email).to be_present

      current_email.click_link 'Confirm Membership'
      fill_in "Password", with: "rubyrubyruby"
      fill_in "Confirm Password", with: "rubyrubyruby"
      fill_in "Postal Address", with: "1 High Street"
      click_button "Register"

      email = emails_sent_to("riley@ruby.test").detect do |mail|
        mail.subject == "Confirmation instructions"
      end
      expect(email).to be_nil

      expect(
        a_request(
          :get, %r{https://api.createsend.com/api/v3.3/subscribers/.*\.json}
        )
      ).to have_been_made.times(MailingList.all.length)

      expect(page).to have_link("Log out")
      expect(page).to have_content("Your membership to Ruby Australia has been confirmed")

      user = Email.find_by(email: "riley@ruby.test")&.user
      expect(user).to be_present
      expect(user).to be_confirmed
      expect(user.valid_password?("rubyrubyruby")).to be(true)
      expect(user.memberships.current.count).to eq(1)
    end

    scenario "accepts an invitation without a provided name" do
      stub_request(
        :get, %r{https://api.createsend.com/api/v3.3/subscribers/.*\.json}
      ).and_return(
        body: JSON.dump("State" => "Active"),
        headers: { "Content-Type" => "application/json" }
      )

      self.current_email = emails_sent_to("charlie@ruby.test").detect do |mail|
        mail.subject == "Ruby Australia Membership"
      end
      expect(current_email).to be_present

      current_email.click_link 'Confirm Membership'
      fill_in "Full Name", with: "Charlotte"
      fill_in "Password", with: "rubyrubyruby"
      fill_in "Confirm Password", with: "rubyrubyruby"
      fill_in "Postal Address", with: "1 High Street"
      click_button "Register"

      email = emails_sent_to("charlie@ruby.test").detect do |mail|
        mail.subject == "Confirmation instructions"
      end
      expect(email).to be_nil

      expect(
        a_request(
          :get, %r{https://api.createsend.com/api/v3.3/subscribers/.*\.json}
        )
      ).to have_been_made.times(MailingList.all.length)

      expect(page).to have_link("Log out")
      expect(page).to have_content("Your membership to Ruby Australia has been confirmed")

      user = Email.find_by(email: "charlie@ruby.test")&.user
      expect(user).to be_present
      expect(user).to be_confirmed
      expect(user.valid_password?("rubyrubyruby")).to be(true)
      expect(user.memberships.current.count).to eq(1)
    end

    scenario "declines an invitation" do
      self.current_email = emails_sent_to("dylan@ruby.test").detect do |mail|
        mail.subject == "Ruby Australia Membership"
      end
      expect(current_email).to be_present

      current_email.click_link "unsubscribing"

      user = Email.find_by(email: "dylan@ruby.test")&.user
      expect(user).not_to be_present

      member = ImportedMember.find_by(email: "dylan@ruby.test")
      expect(member.unsubscribed_at).to be_present
    end

    scenario "respects unsubscribes" do
      ImportedMember.find_each { |member| member.update contacted_at: nil }
      ImportedMember.find_by(email: "dylan@ruby.test").update(
        unsubscribed_at: Time.current
      )

      clear_emails
      SendInvitations.call

      expect(emails_sent_to("riley@ruby.test")).not_to be_empty
      expect(emails_sent_to("dylan@ruby.test")).to be_empty
    end
  end
end
