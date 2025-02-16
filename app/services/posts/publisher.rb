class Posts::Publisher
  def self.call(post)
    new(post).call
  end

  def initialize(post)
    @post = post
  end

  def call
    return unless should_publish?

    PublishPostJob.set(wait_until: @post.publish_scheduled_at).perform_later(@post)
  end

  private

  def should_publish?
    @post.publishable? &&
      (@post.status_before_last_save.blank? || @post.publish_scheduled_at_before_last_save.blank?)
  end
end
