# Class for handling Slack Events via the API https://api.slack.com/apis/connections/events-api
# Each supported event is represented by a class that matches the event type, and that class
# must implement the Event "interface" to be called when a request is sent to the Slack Controller
module Slack
  class EventHandler
    def self.call(event_data:)
      event_class = "Slack::Events::#{event_data[:type]&.classify}".constantize

      event_class.call(event_data)
    rescue NameError, NotImplementedError
      Rails.logger.error "Unknown Slack event"
      false
    end
  end
end
