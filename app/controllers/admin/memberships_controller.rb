class Admin::MembershipsController < Admin::ApplicationController
  expose(:members) do
    memberships = Membership.current.visible.includes(:user).order(:full_name).page(params[:page])
    next memberships if params[:q].blank?

    q = "%#{ActiveRecord::Base.sanitize_sql_like(params[:q])}%"
    user_ids_by_email = Email.where("email ILIKE ?", q).select(:user_id)
    memberships.joins(:user).where(
      %("users"."full_name" ILIKE :q OR "users"."id" IN (:user_ids)),
      q: q,
      user_ids: user_ids_by_email
    )
  end
end
