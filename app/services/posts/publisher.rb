class Posts::Publisher
  def self.call(post)
    new(post).call
  end

  def initialize(post)
    @post = post
  end

  def call
    return unless should_publish?

    @post.publish!
  end

  private

  def should_publish?
    @post.draft? && @post.publish_scheduled_at.present? && @post.publish_scheduled_at <= Time.current
  end
end
