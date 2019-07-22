class MigrateMemberships < ActiveRecord::Migration[5.2]
  def up
    User.find_each do |user|
      next if user.joined_at.nil?

      user.memberships.create(
        joined_at: user.joined_at,
        left_at: user.left_at
      )
    end
  end
end
