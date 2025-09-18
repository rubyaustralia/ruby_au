namespace :posts do
  desc "Publish scheduled posts that are due"
  task publish_scheduled: :environment do
    posts_to_publish = Post.where(status: :scheduled)
                           .where('publish_scheduled_at <= ?', Time.current)
                           .where(published_at: nil)

    puts "Found #{posts_to_publish.count} posts to publish"

    posts_to_publish.find_each do |post|
      post.publish!
      puts "Published post: #{post.title}"
    rescue StandardError => e
      puts "Failed to publish post #{post.id}: #{e.message}"
    end

    puts "Finished publishing scheduled posts"
  end
end
