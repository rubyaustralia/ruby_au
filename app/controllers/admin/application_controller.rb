class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :confirm_is_committee!

  private

  def confirm_is_committee!
    return if current_user.committee?

    redirect_to root_path
  end
end
