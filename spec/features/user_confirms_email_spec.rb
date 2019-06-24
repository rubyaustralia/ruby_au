require "rails_helper"

RSpec.feature "Visitor signs up" do
  let(:user) { create :user, confirmed_at: nil }

  before :each do
    ActionMailer::Base.deliveries.clear
  end

  scenario "by navigating to the page" do
    user

    email = ActionMailer::Base.deliveries.detect do |mail|
      mail.to.include?(user.email) &&
        mail.subject == "Confirmation instructions"
    end
    expect(email).to be_present

    visit email.body.raw_source.match(/href="(?<url>.+?)">/)[:url]

    expect(page).to have_content("Your email address has been successfully confirmed.")
    expect(user.memberships.current.count).to eq(1)
  end
end
