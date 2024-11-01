# frozen_string_literal: true

class Campaigns::Test < Campaigns::Send
  def memberships
    Membership.where(user: User.committee)
  end
end
