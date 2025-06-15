class Admin::DashboardsController < Admin::ApplicationController
  def show
    load_dashboard_data
    load_users_for_management
  end

  private

  def load_dashboard_data
    data = DashboardDataService.new.call

    @member_count = data[:member_count]
    @inactive_members = data[:inactive_members]
    @never_logged_in_members = data[:never_logged_in_members]
    @recently_updated_members = data[:recently_updated_members]
    @recently_logged_in_members = data[:recently_logged_in_members]
    @recent_posts = data[:recent_posts]
    @unpublished_posts = data[:unpublished_posts]
    @recent_campaigns = data[:recent_campaigns]
  end

  def load_users_for_management
    @users_search = params[:users_search] || ''
    @users_role_filter = params[:users_role_filter] || ''

    return @users_for_management = User.none unless search_criteria_present?

    @users_for_management = build_users_query.order(:full_name).limit(10)
  end

  def search_criteria_present?
    @users_search.present? || @users_role_filter.present?
  end

  def build_users_query
    query = User.includes(:emails, :memberships)
    query = apply_search_filter(query) if @users_search.present?
    query = apply_role_filter(query) if @users_role_filter.present?
    query
  end

  def apply_search_filter(query)
    search_term = "%#{@users_search}%"
    query.where(
      "full_name ILIKE ? OR preferred_name ILIKE ? OR email ILIKE ?",
      search_term, search_term, search_term
    )
  end

  def apply_role_filter(query)
    case @users_role_filter
    when 'admin'
      query.where(committee: true)
    when 'member'
      query.where(committee: false)
    else
      query
    end
  end
end
