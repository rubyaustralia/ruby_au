# First, ensure we have a user to associate posts with
user = User.find_or_create_by(email: "author@example.com") do |u|
  u.password = "password123"
  u.password_confirmation = "password123"
  u.full_name = "Blog Author"  # Required field
  u.address = "123 Writer's Lane"  # Required field
  u.confirmed_at = Time.current
  u.mailing_lists = {}
end

unless user.emails.any?
  user.emails.create!(
    email: "author@example.com",
    primary: true,
    confirmed_at: Time.current,
    skip_trigger_after_confirmation: true
  )
end
