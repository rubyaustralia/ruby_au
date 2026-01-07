if Rails.env.development?
  3.times do |i|
    email = "jobseeker#{i + 1}@example.com"

    user = User.find_or_create_by(email:) do |u|
                    u.full_name = "Job Seeker #{i + 1}",
                    u.email = "jobseeker#{i + 1}@example.com",
                    u.password = "password123",
                    u.password_confirmation = "password123",
                    u.address = "123 Test St, Melbourne VIC 3000",
                    u.linkedin_url = "https://www.linkedin.com/in/jobseeker#{i + 1}",
                    u.seeking_work = true,
                    u.confirmed_at = Time.current

      # user.memberships.create!(joined_at: Time.current)
    end
  end
end
