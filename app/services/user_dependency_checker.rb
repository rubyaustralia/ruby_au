class UserDependencyChecker
  def initialize(user)
    @user = user
  end

  def check_dependencies
    dependencies = []

    dependencies.concat(check_rsvps)
    dependencies.concat(check_campaign_deliveries)
    dependencies.concat(check_access_requests)
    dependencies.concat(check_emails)
    dependencies.concat(check_posts)
    dependencies.concat(check_memberships)

    dependencies
  end

  private

  attr_reader :user

  def check_rsvps
    rsvp_count = user.memberships.joins(:rsvps).count
    rsvp_count.positive? ? ["#{rsvp_count} event RSVPs"] : []
  rescue StandardError
    []
  end

  def check_campaign_deliveries
    campaign_delivery_count = user.memberships.joins(:campaign_deliveries).count
    campaign_delivery_count.positive? ? ["#{campaign_delivery_count} campaign deliveries"] : []
  rescue StandardError
    []
  end

  def check_access_requests
    access_request_count = AccessRequest.where(recorder_id: user.id).count
    access_request_count.positive? ? ["#{access_request_count} access requests"] : []
  rescue StandardError
    []
  end

  def check_emails
    email_count = user.emails.count
    email_count.positive? ? ["#{email_count} email records"] : []
  rescue StandardError
    []
  end

  def check_posts
    post_count = Post.where(author: user).count
    post_count.positive? ? ["#{post_count} authored posts"] : []
  rescue StandardError
    []
  end

  def check_memberships
    membership_count = user.memberships.count
    membership_count.positive? ? ["#{membership_count} membership records"] : []
  rescue StandardError
    []
  end
end
