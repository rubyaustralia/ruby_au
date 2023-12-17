# frozen_string_literal: true

require "rails_helper"

RSpec.feature "Committee manages list webhooks", type: :request do
  scenario "registering webhooks" do
    MailingList.each do |list|
      stub_request(:post, "https://api.createsend.com/api/v3.3/lists/#{list.api_id}/webhooks.json")
    end

    MailingList::CreateWebhooks.call

    MailingList.each do |list|
      expect(
        a_request(:post, "https://api.createsend.com/api/v3.3/lists/#{list.api_id}/webhooks.json")
      ).to have_been_made
    end
  end

  scenario "calling a webhook" do
    list = MailingList.all.first
    alex = FactoryBot.create :user, mailing_lists: { list.name => "true" }
    jules = FactoryBot.create :user

    body = <<~JSON
      {
        "Events": [
          {
            "EmailAddress": "#{alex.email}",
            "Type": "Deactivate"
          },
          {
            "EmailAddress": "#{jules.email}",
            "Type": "Subscribe"
          }
        ],
        "ListID": "#{list.api_id}"
      }
    JSON

    post hook_mailing_list_url(list.api_id), params: body, headers: { 'Content-Type' => 'application/json' }

    alex.reload
    jules.reload

    expect(alex.mailing_lists[list.name]).to eq("false")
    expect(jules.mailing_lists[list.name]).to eq("true")
  end
end
