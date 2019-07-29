class Admin::MembershipsController < Admin::ApplicationController
  expose(:members) do
    Membership.current.visible.includes(:user).order(:full_name).page params[:page]
  end
end
