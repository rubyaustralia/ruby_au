# frozen_string_literal: true

class MailingListsController < ApplicationController
  def hook
    events.each do |event|
      handle_list_event event
    end
  end

  private

  def events
    JSON.parse(request.body.read)["Events"]
  end

  def handle_list_event(event)
    user = Email.find_by(email: event["EmailAddress"])&.user
    return if user.nil?

    user.mailing_lists_will_change!

    case event["Type"]
    when "Subscribe"
      user.mailing_lists[list.name] = "true"
    when "Deactivate"
      user.mailing_lists[list.name] = "false"
    end

    user.save
  end

  def list
    @list ||= MailingList.all.detect { |list| list.api_id == params[:id] }
  end
end
