require 'faker'

def update_user(user:, committee: false, seeking_work: false, password: Faker::Internet.password)
  user.password = password
  user.password_confirmation = password
  user.committee = committee
  user.full_name = Faker::Name.name # Required field
  user.address = Faker::Address.full_address # Required field
  user.confirmed_at = Time.current
  user.mailing_lists = {}
  user.seeking_work = seeking_work
  user.linkedin_url = "https://www.linkedin.com/in/#{Faker::Lorem.word}" if seeking_work

  unless user.emails.any?
    user.emails.create!(
      email: user.email,
      primary: true,
      confirmed_at: Time.current,
      skip_trigger_after_confirmation: true
    )
  end
end

return if !Rails.env.development?

committee_users_to_create = 4
job_seeking_users_to_create = 4

# first committee user, with credentials to be mentioned in README
User.find_or_create_by(email: "committee@example.com") { |user| update_user(user:, committee: true, password: "password123") }
puts "Created committee user: committee@example.com with password: password123"

for i in 2..committee_users_to_create
  User.find_or_create_by(email: "committee_#{i}@example.com") { |user| update_user(user:, committee: true) }
  puts "Created committee user: committee_#{i}@example.com"
end

# first job seeker
User.find_or_create_by(email: "jobseeker@example.com") { |user| update_user(user:, seeking_work: true, password: "password123") }
puts "Created job seeker user: jobseeker@example.com with password: password123"

for i in 2..job_seeking_users_to_create
  User.find_or_create_by(email: "jobseeker_#{i}@example.com") { |user| update_user(user:, seeking_work: true) }
  puts "Created job seeker user: jobseeker_#{i}@example.com"
end
