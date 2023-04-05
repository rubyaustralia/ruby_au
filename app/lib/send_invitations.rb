class SendInvitations
  def self.call
    new.call
  end

  def call
    imported_members.each do |member|
      InvitationMailer.invite_member(member).deliver_now

      member.update contacted_at: Time.current
    end
  end

  private

  def imported_members
    ImportedMember.contactable
  end
end
