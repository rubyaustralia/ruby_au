# Preview all emails at http://localhost:3000/rails/mailers/invitation
class InvitationPreview < ActionMailer::Preview
  def invite
    InvitationMailer.with(email: 'test@test.com', first_name: 'John').invite
  end

  def invite_member
    InvitationMailer.invite_member ImportedMember.new(
      full_name: 'Yukihiro Matsumoto',
      email: 'matz@ruby.local',
      token: SecureRandom.uuid,
      data: { sources: ['RubyConf AU 2012', 'Rails Camp 0'] }
    )
  end
end
