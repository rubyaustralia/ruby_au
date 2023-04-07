class InvitationMailer < ApplicationMailer
  def invite
    @email = params[:email]
    @name = params[:name]

    mail(
      to: @email,
      subject: "You're invited to join Ruby Australia"
    )
  end

  def invite_member(member)
    @imported_member = member

    mail(
      to: @imported_member.email,
      subject: 'Ruby Australia Membership'
    )
  end
end
