class UserManagementService
  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  delegate :can_modify_user?, to: :deletion_service

  delegate :delete_user, to: :deletion_service

  delegate :force_delete_user, to: :deletion_service

  delegate :deactivate_user, to: :membership_service

  delegate :update_role, to: :role_service

  delegate :remove_all, to: :membership_service

  private

  attr_reader :user, :current_user

  def deletion_service
    @deletion_service ||= UserManagement::DeletionService.new(user, current_user)
  end

  def role_service
    @role_service ||= UserManagement::RoleService.new(user, current_user)
  end

  def membership_service
    @membership_service ||= UserManagement::MembershipService.new(user, current_user)
  end
end
