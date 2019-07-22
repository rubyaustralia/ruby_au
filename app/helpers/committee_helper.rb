module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end
end
