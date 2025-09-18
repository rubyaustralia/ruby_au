class PublishScheduledPostsJob < ApplicationJob
  queue_as :default

  def perform
    posts_to_publish = Post.where(status: :scheduled)
                           .where('publish_scheduled_at <= ?', Time.current)
                           .where(published_at: nil)

    Rails.logger.info "Found #{posts_to_publish.count} scheduled posts to publish"

    posts_to_publish.find_each do |post|
      post.publish!
      Rails.logger.info "Published scheduled post: #{post.title} (ID: #{post.id})"
    rescue StandardError => e
      Rails.logger.error "Failed to publish scheduled post #{post.id}: #{e.message}"
    end
  end
end
