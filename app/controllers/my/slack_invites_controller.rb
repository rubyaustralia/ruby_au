module My
  class SlackInvitesController < My::ApplicationController
    def show
      redirect_to "https://join.slack.com/t/rubyau/shared_invite/zt-1pewt4vi8-TtrM~UoIJmuH9Niy0Ela6w", allow_other_host: true
    end
  end
end
