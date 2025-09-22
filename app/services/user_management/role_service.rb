class UserManagement::RoleService < UserManagement::BaseService
  def update_role(committee_status)
    return handle_successful_role_update if perform_role_update(committee_status)

    log_role_update_failure
    failure_result('Failed to update user role')
  rescue StandardError => e
    log_role_update_exception(e)
    failure_result("Failed to update user role: #{e.message}")
  end

  private

  def perform_role_update(committee_status)
    user.update!(committee: committee_status)
    true
  rescue StandardError
    false
  end

  def handle_successful_role_update
    success_result("#{user.full_name || user.email || 'User'}'s role updated successfully")
  end

  def log_role_update_failure
    Rails.logger.error "Failed to update user role for user #{user.id}"
  end

  def log_role_update_exception(exception)
    Rails.logger.error "Exception in update_role for user #{user.id}: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
  end
end
