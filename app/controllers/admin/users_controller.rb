class Admin::UsersController < Admin::ApplicationController
  def search
    @users = if params[:q].present? && params[:q].length >= 2
               User.includes(:emails).search(params[:q]).limit(10)
             else
               []
             end

    render json: @users.map { |u| { id: u.id, name: u.full_name, email: u.primary_email } }
  end
end
