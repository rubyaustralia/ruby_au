module MeetupAdminHelper
  def current_meetup_admin?
    user_signed_in? && current_user.meetup_admin?
  end
end
