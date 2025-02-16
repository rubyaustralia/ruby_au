class PublishPostJob < ApplicationJob
  queue_as :default

  def perform(post)
    return unless post.publishable?

    post.publish!
  end
end
