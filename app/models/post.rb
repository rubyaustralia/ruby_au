class Post < ApplicationRecord
  extend FriendlyId
  friendly_id :slug_candidate, use: :slugged

  has_rich_text :content

  enum :status, { draft: 0, scheduled: 1, published: 2, archived: 3 }, default: :draft
  enum :category, { news: 0, announcements: 1 }, default: :news

  validates :title, :content, :category, :user, presence: true
  validates :slug, uniqueness: true, allow_nil: true

  belongs_to :user

  def publish!
    update!(status: :published, published_at: Time.current)
  end

  def normalize_friendly_id(text)
    text # Return the text unchanged, maintaining the forward slashes
  end

  private

  def slug_candidate
    if published_at.present?
      formatted_date = "#{published_at.year}/#{published_at.month}/#{published_at.day}"
      [
        "#{formatted_date}/#{normalize_title}"
      ]
    else
      [normalize_title]
    end
  end

  def normalize_title
    title.downcase
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
