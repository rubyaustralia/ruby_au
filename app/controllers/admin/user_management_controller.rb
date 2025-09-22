class Admin::UserManagementController < Admin::ApplicationController
  def update_role
    @user = User.find(params[:user_id])
    service = UserManagementService.new(@user, current_user)
    result = service.update_role(params[:committee] == 'true')

    respond_with_result(result, :replace_user_row)
  end

  def delete
    @user = User.find(params[:user_id])
    service = UserManagementService.new(@user, current_user)
    result = service.delete_user

    respond_with_action_result(result, :remove_user_row)
  end

  def force_delete
    @user = User.find(params[:user_id])
    service = UserManagementService.new(@user, current_user)
    result = service.force_delete_user

    respond_with_action_result(result, :remove_user_row)
  end

  def deactivate
    @user = User.find(params[:user_id])
    service = UserManagementService.new(@user, current_user)
    result = service.deactivate_user

    respond_with_result(result, :replace_user_row)
  end

  private

  def respond_with_action_result(result, success_action)
    return respond_with_result(result, success_action) if result[:success]

    message_type = 'error'
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: notification_stream(result[:message], message_type)
      end
      format.html { redirect_with_flash(result[:message], message_type) }
    end
  end

  def respond_with_result(result, action_type)
    message_type = result[:success] ? 'success' : 'error'

    respond_to do |format|
      format.turbo_stream do
        streams = build_turbo_streams(action_type, result[:success])
        streams << notification_stream(result[:message], message_type)
        render turbo_stream: streams
      end
      format.html { redirect_with_flash(result[:message], message_type) }
    end
  end

  def build_turbo_streams(action_type, success)
    case action_type
    when :replace_user_row
      success ? [user_row_replacement_stream] : []
    when :remove_user_row
      success ? [user_row_removal_stream] : []
    else
      []
    end
  end

  def user_row_replacement_stream
    turbo_stream.replace("user_row_#{@user.id}",
                         partial: 'admin/dashboards/user_row',
                         locals: { user: @user })
  end

  def user_row_removal_stream
    turbo_stream.remove("user_row_#{@user.id}")
  end

  def notification_stream(message, type)
    turbo_stream.append('notifications',
                        partial: 'shared/notification',
                        locals: { message: message, type: type })
  end

  def redirect_with_flash(message, type)
    flash_type = type == 'success' ? :notice : :alert
    redirect_to admin_dashboard_path, flash_type => message
  end
end
