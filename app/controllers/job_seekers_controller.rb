class JobSeekersController < ApplicationController
  def index
    @open_to_work = User.seeking_work.includes(:memberships).where(memberships: { left_at: nil }).order(created_at: :desc)
    @display_limit = 30
  end
end
