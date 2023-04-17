# Preview all emails at http://localhost:3000/rails/mailers/invitation
class InvitationPreview < ActionMailer::Preview
  def invite
    InvitationMailer.with(email: 'test@test.com', name: 'John Doe').invite
  end

  def invite_member
    InvitationMailer.with(
      email: 'john.doe@test.com',
      name: 'John Doe',
      sources: ["Some Conference"],
      token: 'some-token'
    ).invite
  end
end
