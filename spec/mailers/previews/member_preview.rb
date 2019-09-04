class MemberPreview < ActionMailer::Preview
  def invite
    MemberInvitationMailer.invite ImportedMember.new(
      full_name: 'Yukihiro Matsumoto',
      email: 'matz@ruby.local',
      token: SecureRandom.uuid,
      data: { sources: ['RubyConf AU 2012', 'Rails Camp 0'] }
    )
  end
end
