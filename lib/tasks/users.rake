# frozen_string_literal: true

namespace :users do
  task unsubscribe_spammers: :environment do
    User.unconfirmed.subscribed_to_any_list.each do |user|
      MailingList.all.find do |list|
        next unless user.mailing_lists[list.name] == "true"

        begin
          MailingList::Unsubscribe.call user, list
        rescue CreateSend::BadRequest => e
          raise e unless e.message[/Subscriber not in list/]
        end
      end
    end
  end
end
