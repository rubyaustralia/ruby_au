namespace :imported_members do
  desc "Invite not-yet-contacted imported members from events"
  task invite: :environment do
    SendInvitations.call
  end
end
