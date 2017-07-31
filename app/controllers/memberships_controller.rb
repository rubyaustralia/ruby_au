class MembershipsController < ApplicationController
  before_action :authenticate!

  def create
    current_user.create_membership
    report_errors current_user, 'Your membership is created'

    redirect_to profile_path
  end

  def destroy
    current_user.cancel_membership
    report_errors current_user, 'Your membership is cancelled'

    redirect_to profile_path
  end
end
