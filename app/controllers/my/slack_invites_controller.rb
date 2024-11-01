module My
  class SlackInvitesController < My::ApplicationController
    def show
      redirect_to "https://join.slack.com/t/rubyau/shared_invite/#{ENV['SLACK_INVITE_ID']}", allow_other_host: true
    end
  end
end
