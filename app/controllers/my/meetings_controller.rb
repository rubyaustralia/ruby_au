class My::MeetingsController < My::ApplicationController
  expose(:meetings) { RsvpEvent.upcoming }
end
