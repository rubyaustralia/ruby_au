class Admin::MembershipsController < Admin::ApplicationController
  expose(:members) do
    memberships = Membership.current.visible.includes(:user).order(:full_name).page(params[:page])
    next memberships if params[:q].blank?

    memberships.where(
      %("users"."email" ILIKE :q OR "users"."full_name" ILIKE :q),
      q: "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"
    )
  end
end
