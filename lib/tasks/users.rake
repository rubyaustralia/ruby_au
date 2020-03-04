# frozen_string_literal: true

namespace :users do
  task unsubscribe_spammers: :environment do
    User.unconfirmed.old.subscribed_to_any_list.each do |user|
      user.mailing_lists_will_change!

      MailingList::LISTS.each do |list|
        user.mailing_lists[list] = "false"
      end
      user.save

      begin
        MailingList::Apply.call(user)
      rescue CreateSend::BadRequest => error
        raise error unless error.message[/Subscriber not in list/]
      end
    end
  end
end
