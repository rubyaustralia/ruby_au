class Admin::UsersController < Admin::ApplicationController
  def search
    query = params[:q]
    if query.present? && query.length >= 2
      search_term = "%#{query}%"
      @users = User.includes(:emails)
                   .where("full_name ILIKE ? OR preferred_name ILIKE ?", search_term, search_term)
                   .limit(10)
    else
      @users = []
    end

    render json: @users.map { |u| { id: u.id, name: u.full_name, email: u.primary_email } }
  end
end
