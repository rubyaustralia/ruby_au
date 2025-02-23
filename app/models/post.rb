class Post < ApplicationRecord
  paginates_per 10

  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

  has_rich_text :content

  enum :status, { draft: 0, scheduled: 1, published: 2, archived: 3 }, default: :draft
  enum :category, { news: 0, announcements: 1 }, default: :news

  validates :title, :content, :category, :user, presence: true
  validate :prevent_duplicated_slug

  belongs_to :user

  scope :published_with_associations, lambda {
    published
      .includes(:user, :rich_text_content)
      .order(published_at: :desc)
  }

  scope :filter_by_category, lambda { |category|
    category.present? ? where(category: category) : all
  }

  def publishable?
    draft? && publish_scheduled_at.present?
  end

  def editable?
    draft? && publish_scheduled_at.blank?
  end

  def publish!
    update!(status: :published, published_at: Time.current)
  end

  def normalize_friendly_id(text)
    text # Return the text unchanged, maintaining the forward slashes
  end

  private

  def prevent_duplicated_slug
    return unless self.class.where(slug: normalize_title).or(self.class.where("slug ILIKE ?", "%/#{normalize_title}")).where.not(id: id).exists?

    errors.add(:slug, 'is already taken')
  end

  def slug_candidate
    if published_at.present?
      formatted_date = published_at.strftime("%Y/%-m/%-d")
      [
        "#{formatted_date}/#{normalize_title}"
      ]
    else
      [normalize_title]
    end
  end

  def normalize_title
    title.to_s
         .downcase
         .gsub(/[^a-z0-9\s-]/, '')
         .strip
         .gsub(/\s+/, ' ')
         .split(' ')
         .first(10)
         .join('-')
  end

  def should_generate_new_friendly_id?
    will_save_change_to_published_at? || will_save_change_to_title?
  end
end
