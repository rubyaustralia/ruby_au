if Rails.env.development?
  3.times do |i|
    user = User.create!(
      full_name: "Job Seeker #{i + 1}",
      email: "jobseeker#{i + 1}@example.com",
      password: "password123",
      password_confirmation: "password123",
      address: "123 Test St, Melbourne VIC 3000",
      linkedin_url: "https://www.linkedin.com/in/jobseeker#{i + 1}",
      seeking_work: true,
      confirmed_at: Time.current
    )

    user.memberships.create!(joined_at: Time.current)

    puts "Created job seeker: #{user.full_name}"
  end
end
