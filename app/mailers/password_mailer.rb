class PasswordMailer < ApplicationMailer
  def change_password(user)
    @user = user
    mail(to: @user.email, subject: 'Change your password')
  end
end
