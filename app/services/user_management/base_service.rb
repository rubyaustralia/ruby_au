class UserManagement::BaseService
  def initialize(user, current_user)
    @user = user
    @current_user = current_user
  end

  def can_modify_user?
    user != current_user
  end

  private

  attr_reader :user, :current_user

  def success_result(message)
    { success: true, message: message }
  end

  def failure_result(message)
    { success: false, message: message }
  end
end
