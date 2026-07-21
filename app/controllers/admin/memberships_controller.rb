class Admin::MembershipsController < Admin::ApplicationController
  expose(:members) do
    memberships = Membership.current.visible.includes(:user).order(:full_name).page(params[:page])
    next memberships if params[:q].blank?

    memberships.joins(:user).merge(User.search(params[:q]))
  end
end
