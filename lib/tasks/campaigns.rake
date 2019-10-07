# frozen_string_literal: true

namespace :campaigns do
  desc "Send emails for a given campaign"
  task send: :environment do
    Campaigns::Send.call Campaign.find(ENV["CAMPAIGN_ID"])
  end
end
