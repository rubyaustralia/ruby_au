class SessionsController < Clearance::SessionsController
  protected

  def url_after_create
    edit_user_path(@user)
  end
end
