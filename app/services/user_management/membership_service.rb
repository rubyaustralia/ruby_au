class UserManagement::MembershipService < UserManagement::BaseService
  def deactivate_user
    return failure_result('You cannot deactivate your own account') unless can_modify_user?

    current_memberships = user.memberships.where(left_at: nil)
    current_memberships.each { |membership| membership.update!(left_at: Time.current) }

    success_result("#{user.full_name}'s membership has been deactivated")
  rescue StandardError
    failure_result('Failed to deactivate user membership')
  end

  def remove_all
    log_removal_start
    remove_membership_associations
    remove_memberships
    remove_extra_emails
    remove_access_requests
    nullify_authored_posts
    log_removal_completion
  end

  private

  def log_removal_start
    Rails.logger.info "Starting removal of associations for user #{user.id}"
  end

  def log_removal_completion
    Rails.logger.info "Completed membership associations removal"
    Rails.logger.info "Completed memberships removal"
    Rails.logger.info "Completed emails removal"
    Rails.logger.info "Completed access requests removal"
    Rails.logger.info "Completed posts handling"
  end
end
