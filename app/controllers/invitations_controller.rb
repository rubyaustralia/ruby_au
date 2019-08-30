class InvitationsController < ApplicationController
  expose(:user) { User.new user_params }
  expose(:imported_member) { ImportedMember.find_by token: params[:id] }

  def create
    if user.valid?
      user.confirmed_at = Time.current
      user.save!

      sign_in user

      redirect_to root_path, notice: "Your membership to Ruby Australia has been confirmed."
    else
      render :new
    end
  end

  def unsubscribe
    imported_member.update unsubscribed_at: Time.current

    redirect_to root_path, notice: "You have been unsubscribed from membership invitations."
  end

  private

  def user_params
    hash = params.fetch(:user, {}).permit(
      :full_name, :email, :password, :password_confirmation, :address, :visible
    )

    hash[:full_name] ||= imported_member.full_name
    hash[:email]     ||= imported_member.email

    hash
  end
end
