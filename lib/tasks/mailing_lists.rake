# frozen_string_literal: true

namespace :mailing_lists do
  desc "Synchronise mailing list information from Campaign Monitor"
  task sync: :environment do
    MailingList::Sync.call
  end
end
