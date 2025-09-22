class UserManagement::DeletionService < UserManagement::BaseService
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

    perform_force_delete
    success_result("#{user.full_name} and all associated records have been force deleted")
  rescue StandardError => e
    log_force_delete_error(e)
    failure_result("Failed to force delete user: #{e.message}")
  end

  private

  def perform_force_delete
    ActiveRecord::Base.transaction do
      UserAssociationRemover.new(user).remove_all
      user.destroy!
    end
  end

  def log_force_delete_error(error)
    Rails.logger.error "Force delete failed for user #{user.id}: #{error.message}"
    Rails.logger.error error.backtrace.join("\n")
  end

  def dependency_error(dependencies)
    message = "Cannot delete #{user.full_name} - user has associated records: #{dependencies.join(', ')}. Consider deactivating the membership instead."
    failure_result(message)
  end

  def extract_table_from_error(error_message)
    match = error_message.match(/table "([^"]+)"/)
    match ? match[1] : "unknown table"
  end
end
