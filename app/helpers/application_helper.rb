module ApplicationHelper
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
end
