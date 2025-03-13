# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# db/seeds.rb

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

# Sample blog posts with valid category values (0 for news, 1 for announcements)
posts = [
  {
    title: "Getting Started with Ruby on Rails",
    slug: "getting-started-with-ruby-on-rails",  # Initial slug, will be adjusted by FriendlyId
    content: "An introduction to building web applications with Rails...",
    status: 2,  # published
    published_at: Time.now,
    category: 0,  # news
    user: user
  },
  {
    title: "Database Optimization Techniques",
    slug: "database-optimization-techniques",
    content: "Learn how to improve your database performance...",
    status: 2,  # published
    published_at: 1.day.ago,
    category: 1,  # announcements
    user: user
  },
  {
    title: "REST API Best Practices",
    slug: "rest-api-best-practices",
    content: "Designing efficient and scalable APIs...",
    status: 2,  # published
    published_at: 2.days.ago,
    category: 0,  # news
    user: user
  },
  {
    title: "Understanding MVC Architecture",
    slug: "understanding-mvc-architecture",
    content: "Breaking down Model-View-Controller pattern...",
    status: 1,  # scheduled
    publish_scheduled_at: 2.days.from_now,
    category: 1,  # announcements
    user: user
  },
  {
    title: "Deploying Rails Applications",
    slug: "deploying-rails-applications",
    content: "Step-by-step guide to deployment...",
    status: 2,  # published
    published_at: 3.days.ago,
    category: 1,  # announcements
    user: user
  },
  {
    title: "Authentication in Web Apps",
    slug: "authentication-in-web-apps",
    content: "Implementing secure authentication...",
    status: 2,  # published
    published_at: 4.days.ago,
    category: 0,  # news
    user: user
  },
  {
    title: "Testing Strategies for Developers",
    slug: "testing-strategies-for-developers",
    content: "Writing effective tests for your code...",
    status: 1,  # scheduled
    publish_scheduled_at: 1.day.from_now,
    category: 1,  # announcements
    user: user
  },
  {
    title: "Caching in Rails",
    slug: "caching-in-rails",
    content: "Improving performance with caching...",
    status: 2,  # published
    published_at: 5.days.ago,
    category: 1,  # announcements
    user: user
  },
  {
    title: "Web Security Basics",
    slug: "web-security-basics",
    content: "Protecting your applications from threats...",
    status: 2,  # published
    published_at: 6.days.ago,
    category: 0,  # news
    user: user
  },
  {
    title: "Building Real-time Features",
    slug: "building-real-time-features",
    content: "Adding real-time functionality to apps...",
    status: 2,  # published
    published_at: 7.days.ago,
    category: 1,  # announcements
    user: user
  }
]

# Create posts
posts.each do |post_attrs|
  Post.find_or_create_by(slug: post_attrs[:slug]) do |post|
    # Handle rich text content
    post.content = post_attrs[:content]
    post.assign_attributes(post_attrs.except(:content))
    puts "Created post: #{post.title}"
  end
end

puts "Seeded #{posts.count} blog posts"
