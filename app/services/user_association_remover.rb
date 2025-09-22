class UserAssociationRemover
  def initialize(user)
    @user = user
  end

  def remove_all
    remove_membership_associations
    remove_memberships
    remove_extra_emails
    remove_access_requests
    nullify_authored_posts
  end

  private

  attr_reader :user

  def remove_membership_associations
    user.memberships.each do |membership|
      remove_membership_rsvps(membership)
      remove_membership_campaign_deliveries(membership)
    end
  end

  def remove_membership_rsvps(membership)
    membership.rsvps.destroy_all
  end

  def remove_membership_campaign_deliveries(membership)
    return unless defined?(CampaignDelivery)

    CampaignDelivery.where(membership_id: membership.id).destroy_all
  rescue NameError
    # CampaignDelivery class doesn't exist, skip
  end

  def remove_memberships
    user.memberships.destroy_all
  end

  def remove_extra_emails
    user.emails.destroy_all
  end

  def remove_access_requests
    return unless defined?(AccessRequest)

    AccessRequest.where(recorder_id: user.id).destroy_all
  end

  def nullify_authored_posts
    return unless defined?(Post)

    Rails.logger.info "Removing posts for user #{user.id}"
    Post.where(user_id: user.id).destroy_all
    Rails.logger.info "Completed posts removal for user #{user.id}"
  end
end
