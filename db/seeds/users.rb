require 'faker'

# rubocop:disable Rails/Output, Metrics/MethodLength, Metrics/AbcSize
def update_user(user:, committee: false, seeking_work: false, password: nil)
  password_specified = password.present?

  user.password = password_specified ? password : Faker::Internet.password
  user.password_confirmation = password
  user.committee = committee
  user.full_name = Faker::Name.name # Required field
  user.address = Faker::Address.full_address # Required field
  user.confirmed_at = Time.current
  user.mailing_lists = {}
  user.seeking_work = seeking_work
  user.linkedin_url = "https://www.linkedin.com/in/#{Faker::Lorem.word}" if seeking_work

  print "Created or updated user with primary email: #{user.email}"
  print " and password: #{user.password}" if password_specified
  print ". "
end
# rubocop:enable Rails/Output, Metrics/MethodLength, Metrics/AbcSize

def add_secondary_email_if_not_present(user:)
  return unless user.emails&.size == 1

  secondary_email_address = user.email.gsub('@', "_secondary@")
  user.emails.create!(
    email: secondary_email_address,
    primary: false,
    confirmed_at: Time.current,
    skip_trigger_after_confirmation: true
  )
  print "Secondary email: #{secondary_email_address} added." # rubocop:disable Rails/Output
end

def seed_user(email:, &block)
  user = User.find_or_create_by!(email:, &block)
  add_secondary_email_if_not_present(user:)
  puts # rubocop:disable Rails/Output
end

return unless Rails.env.development?

committee_users_to_create = 4
job_seeking_users_to_create = 14

# first committee user, with credentials to be mentioned in README
seed_user(email: "committee@example.com") { |user| update_user(user:, committee: true, password: "password123") }

(2..committee_users_to_create).each do |i|
  seed_user(email: "committee_#{i}@example.com") { |user| update_user(user:, committee: true) }
end

# first job seeker, with credentials to be mentioned in README
seed_user(email: "jobseeker@example.com") { |user| update_user(user:, seeking_work: true, password: "password123") }

(2..job_seeking_users_to_create).each do |i|
  seed_user(email: "jobseeker_#{i}@example.com") { |user| update_user(user:, seeking_work: true) }
end
