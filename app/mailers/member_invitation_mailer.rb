class MemberInvitationMailer < ApplicationMailer
  def invite(imported_member)
    @imported_member = imported_member

    mail(
      to: @imported_member.email,
      subject: 'Ruby Australia Membership'
    )
  end
end
