# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Committee synchonising mailing lists", type: :feature do
  before do
    ENV["RUBYCONF_AU_LIST_ID"] ||= "conf-key"
    ENV["RAILSGIRLS_LIST_ID"]  ||= "girls-key"
  end

  it "updates user flags" do
    alex = FactoryBot.create(
      :user, mailing_lists: {'RubyConf AU' => "false", 'RailsGirls' => "true"}
    )
    jules = FactoryBot.create :user

    stub_request(
      :get, %r{https://api.createsend.com/api/v3.2/lists/conf-key/active.json}
    ).to_return(
      body: JSON.dump({
        'Results' => [
          {'EmailAddress' => alex.email},
          {'EmailAddress' => 'frankie@ruby.local'}
        ],
        'PageNumber' => 1,
        'NumberOfPages' => 1
      }),
      headers: {'Content-Type' => 'application/json'}
    )

    stub_request(
      :get, %r{https://api.createsend.com/api/v3.2/lists/girls-key/active.json}
    ).to_return(
      body: JSON.dump({
        'Results' => [
          {'EmailAddress' => jules.email},
          {'EmailAddress' => 'frankie@ruby.local'}
        ],
        'PageNumber' => 1,
        'NumberOfPages' => 1
      }),
      headers: {'Content-Type' => 'application/json'}
    )

    MailingList::Sync.call

    alex.reload
    jules.reload

    expect(alex.mailing_lists['RubyConf AU']).to eq("true")
    expect(alex.mailing_lists['RailsGirls']).to eq("false")
    expect(jules.mailing_lists['RailsGirls']).to eq("true")
    expect(jules.mailing_lists['RubyConf AU']).to eq("false")
  end
end
