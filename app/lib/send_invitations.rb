class SendInvitations
  def self.call
    new.call
  end

  def call
    imported_members.each do |member|
      MemberInvitationMailer.invite(member).deliver_now

      member.update contacted_at: Time.current
    end
  end

  private

  def imported_members
    ImportedMember.contactable
  end
end
