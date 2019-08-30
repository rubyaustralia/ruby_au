class My::AccessRequestsController < My::ApplicationController
  expose(:access_requests) do
    AccessRequest.order(created_at: :desc).page params[:page]
  end
end
