module ApplicationHelper
  def committee
    YAML.load_file Rails.root.join('config', 'data', 'committee.yml')
  end

  def link_to_external(name = nil, options = nil, html_options = {}, &block)
    svg = inline_svg "external-link.svg", height: 12
    html_options[:target] ||= "_blank"
    html_options[:rel]    ||= "external"

    if block_given?
      link_to capture(&block).strip.html_safe + svg, options, html_options
    else
      link_to (name + svg).html_safe, options, html_options
    end
  end

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML.new)
  end

  def markdown_to_html(raw)
    return nil if raw.nil?

    markdown.render(raw).strip.html_safe
  end

  def previous
    YAML.load_file Rails.root.join('config', 'data', 'previous.yml')
  end
end
