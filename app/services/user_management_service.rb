class UserManagementService
  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  def can_modify_user?
    user != current_user
  end

  def delete_user
    return failure_result('You cannot delete your own account') unless can_modify_user?

    dependencies = UserDependencyChecker.new(user).check_dependencies
    return dependency_error(dependencies) if dependencies.any?

    user.destroy!
    success_result("#{user.full_name} has been deleted successfully")
  rescue ActiveRecord::InvalidForeignKey => e
    table_name = extract_table_from_error(e.message)
    failure_result("Cannot delete #{user.full_name} - user has associated records in #{table_name}. Please contact a developer to resolve this.")
  rescue StandardError
    failure_result('Failed to delete user due to an unexpected error')
  end

  def force_delete_user
    return failure_result('You cannot delete your own account') unless can_modify_user?

    ActiveRecord::Base.transaction do
      UserAssociationRemover.new(user).remove_all
      user.destroy!
    end

    success_result("#{user.full_name} and all associated records have been force deleted")
  rescue StandardError => e
    failure_result("Failed to force delete user: #{e.message}")
  end

  def deactivate_user
    return failure_result('You cannot deactivate your own account') unless can_modify_user?

    current_memberships = user.memberships.where(left_at: nil)
    current_memberships.each { |membership| membership.update!(left_at: Time.current) }

    success_result("#{user.full_name}'s membership has been deactivated")
  rescue StandardError
    failure_result('Failed to deactivate user membership')
  end

  def update_role(committee_status)
    if user.update(committee: committee_status)
      success_result("#{user.full_name}'s role updated successfully")
    else
      failure_result('Failed to update user role')
    end
  end

  private

  attr_reader :user, :current_user

  def dependency_error(dependencies)
    message = "Cannot delete #{user.full_name} - user has associated records: #{dependencies.join(', ')}. Consider deactivating the membership instead."
    failure_result(message)
  end

  def success_result(message)
    { success: true, message: message }
  end

  def failure_result(message)
    { success: false, message: message }
  end

  def extract_table_from_error(error_message)
    match = error_message.match(/table "([^"]+)"/)
    match ? match[1] : "unknown table"
  end
end
