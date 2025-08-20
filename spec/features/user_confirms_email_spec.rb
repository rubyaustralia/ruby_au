require "rails_helper"

RSpec.feature "User confirms account", type: :feature do
  let(:user) do
    create :user, confirmed_at: nil, mailing_lists: { "Ruby Retreat" => "true" }
  end

  before do
    ActionMailer::Base.deliveries.clear
  end

  scenario "by clicking the link in an email" do
    stub_request(
      :get, %r{https://api.createsend.com/api/v3.3/subscribers/camp-key.json}
    ).and_return(
      body: JSON.dump("State" => "Active"),
      headers: { "Content-Type" => "application/json" }
    )

    stub_request(
      :get, %r{https://api.createsend.com/api/v3.3/subscribers/conf-key.json}
    ).and_return(
      body: JSON.dump("State" => "Unsubscribed"),
      headers: { "Content-Type" => "application/json" }
    )

    stub_request(
      :get, %r{https://api.createsend.com/api/v3.3/subscribers/girls-key.json}
    ).and_return(
      status: 400,
      body: JSON.dump("Code" => 203, "Message" => "Subscriber not in list"),
      headers: { "Content-Type" => "application/json" }
    )

    stub_request(
      :post, "https://api.createsend.com/api/v3.3/subscribers/camp-key.json"
    )

    user

    email = emails_sent_to(user.email).detect do |mail|
      mail.subject == "Confirmation instructions"
    end
    expect(email).to be_present

    email.click_link 'Confirm my membership'

    expect(page).to have_content("Your email address has been successfully confirmed.")

    user.reload
    expect(user).to be_confirmed
    expect(user.memberships.current.count).to eq(1)
    expect(user.mailing_lists["Ruby Retreat"]).to eq("true")
    expect(user.mailing_lists["RubyConf AU"]).to eq("false")
    expect(user.mailing_lists["RailsGirls"]).to eq("false")

    expect(
      a_request(
        :post, "https://api.createsend.com/api/v3.3/subscribers/camp-key.json"
      )
    ).to have_been_made.once
  end
end
