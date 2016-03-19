class RootRouteConstraints
  def self.matches?(request)
    pattern = file_pattern(request.path)

    Dir.glob(pattern).any?
  end

  private

  def self.file_pattern(page_id)
    base_page_id = page_id.sub(/\.html$/, '')
    "#{content_path}#{base_page_id}.html*"
  end

  def self.content_path
    Rails.root.join('app', 'views', 'pages').to_s
  end
end
