class DevisePreview < ActionMailer::Preview
  def confirmation
    Devise::Mailer.confirmation_instructions(User.first, 'token')
  end

  def email_changed
    user = User.first
    user.unconfirmed_email = 'changed@ruby.test'

    Devise::Mailer.email_changed(user)
  end

  def password_change
    Devise::Mailer.password_change(User.first)
  end

  def reset_password_instructions
    Devise::Mailer.reset_password_instructions(User.first, 'token')
  end
end
