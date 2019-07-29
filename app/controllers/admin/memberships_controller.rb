class Admin::MembershipsController < Admin::ApplicationController
  expose(:members) do
    Membership.current.visible.includes(:user).order(:full_name)
  end
end
