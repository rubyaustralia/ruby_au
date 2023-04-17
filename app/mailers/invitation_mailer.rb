class InvitationMailer < ApplicationMailer
  def invite
    @email = params[:email]
    @name = params[:name]
    @token = params[:token]
    @sources = params[:sources]

    mail(
      to: @email,
      subject: "Ruby Australia Membership"
    )
  end
end
