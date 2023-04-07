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
