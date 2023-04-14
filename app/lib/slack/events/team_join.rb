# https://api.slack.com/events/team_join
module Slack
  module Events
    class TeamJoin
      def self.call(event_data = {})
        email = event_data.dig(:user, :profile, :email)
        name = event_data.dig(:user, :real_name)

        return if !email || User.exists?(email: email)

        InvitationMailer.with(email: email, name: name)
                        .invite
                        .deliver_now
      end
    end
  end
end
