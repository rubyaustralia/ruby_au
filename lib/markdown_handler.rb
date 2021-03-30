class MarkdownHandler
  class << self
    def render(text)
      key = cache_key(text)
      Rails.cache.fetch key do
        # rubocop:disable Rails/OutputSafety
        markdown.render(text).html_safe
        # rubocop:enable Rails/OutputSafety
      end
    end

    private

    def cache_key(text)
      Digest::MD5.hexdigest(text)
    end

    def markdown
      @markdown ||= Redcarpet::Markdown.new(HTMLWithPygments, fenced_code_blocks: true, autolink: true, space_after_headers: true)
    end
  end

  class HTMLWithPygments < Redcarpet::Render::HTML
    def block_code(code, lang)
      lang = lang&.split&.first || "text"
      add_code_tags(
        Pygmentize.process(code, lang), lang
      )
    end

    def add_code_tags(code, lang)
      code = code.sub(/<pre>/, %{<div class="lang">#{lang}</div><pre><code  class="' + lang + '">})
      code.sub(/<\/pre>/, "</code></pre>")
    end
  end
end
