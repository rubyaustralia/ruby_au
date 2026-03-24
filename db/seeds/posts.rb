def generate_posts(users:)
  posts = []

  Post.categories.each_value do |value|
    3.times do
      posts << post_attributes(category: value, user: users.sample, draft: true)

      posts << post_attributes(category: value, user: users.sample, future_scheduled: false)

      posts << post_attributes(category: value, user: users.sample, future_scheduled: true)
    end
  end
  posts
end

def heading
  Faker::Lorem.words.join(' ').titlecase
end

def post_attributes(category:, user:, draft: false, future_scheduled: false)
  title = heading
  slug = title.parameterize # Initial slug, will be adjusted by FriendlyId

  {
    title:,
    slug:,
    content: rand(1..2) == 1 ? post_content_simple : post_content_enhanced,
    category:,
    user:,
    **post_scheduling_attributes(draft: draft, future_scheduled: future_scheduled)
  }
end

def post_content_simple
  content = Faker::Lorem.paragraph(sentence_count: 4, supplemental: true, random_sentences_to_add: 4)
  content += " <a href='https://www.example.com'>#{heading}</a>"
  content
end

def post_content_enhanced
  content = "<strong>#{heading} #{Faker::Lorem.multibyte}</strong><br />"
  content += "<em>#{Faker::Lorem.paragraph(sentence_count: 4, supplemental: true, random_sentences_to_add: 4)}</em>"
  content += "<br /><br />"

  content += "<strong>#{heading}</strong><br />"

  3.times do
    content += Faker::Lorem.paragraph(sentence_count: 8, supplemental: true, random_sentences_to_add: 4)
    content += "<br /><br />"
  end

  content
end

def post_scheduling_attributes(draft: false, future_scheduled: false)
  return { status: 0 } if draft

  if future_scheduled
    return {
      status: 1, # scheduled
      publish_scheduled_at: Faker::Time.between(from: 2.days.from_now, to: 2.weeks.from_now)
    }
  end

  {
    published_at: Faker::Time.between(from: 4.months.ago, to: 1.week.ago), status: 2, # published
  }
end

return unless Rails.env.development?

users = User.where(committee: true)
return if users.empty?

post_attributes_list = generate_posts(users:)
existing_posts_by_slug = Post.where(slug: post_attributes_list.map { |post_attrs| post_attrs[:slug] }).index_by(&:slug)

# Create posts
post_attributes_list.each do |post_attrs|
  next if existing_posts_by_slug.key?(post_attrs[:slug])

  Post.create!(post_attrs) do |post|
    # Handle rich text content
    post.content = post_attrs[:content]

    puts "Created post: #{post.title}" # rubocop:disable Rails/Output
  end
end
