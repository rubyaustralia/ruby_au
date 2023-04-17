module Slack
  class EventHandler
    def self.call(event_data:)
      case event_data[:type]
      when "team_join"
        Slack::Events::TeamJoin.call(event_data)
      else
        Rails.logger.debug "Unhandled Slack event: #{event_data[:type]}"
        false
      end
    end
  end
end
