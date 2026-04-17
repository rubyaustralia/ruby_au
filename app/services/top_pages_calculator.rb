class TopPagesCalculator
  def call
    Ahoy::Event.where(name: "$view")
               .where("time >= ?", 30.days.ago)
               .group("properties->>'url'")
               .count
               .map { |url, views| [normalize_url(url), views] }
               .group_by(&:first)
               .transform_values { |v| v.sum(&:last) }
               .sort_by { |_page, views| -views }
               .first(10)
               .to_h
  end

  private

  def normalize_url(url)
    return 'Unknown Page' if url.blank?

    uri = URI.parse(url)
    path = uri.path
    path = "/" if path.blank?
    path
  rescue URI::InvalidURIError
    url
  end
end
