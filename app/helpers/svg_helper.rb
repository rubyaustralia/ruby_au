module SvgHelper
  def vite_inline_svg(name, options = {})
    svg_file_path = Rails.root.join('app', 'frontend', 'images', name.to_s)

    return "SVG not found: #{name}" unless File.exist?(svg_file_path)

    svg_content = File.read(svg_file_path)
    process_svg_content(svg_content, options)
  end

  private

  def process_svg_content(svg_content, options)
    doc = Nokogiri::HTML::DocumentFragment.parse(svg_content)
    svg = doc.at_css('svg')

    apply_options_to_svg(svg, options) if svg

    sanitize_svg(doc)
  end

  def apply_options_to_svg(svg, options)
    options.each { |key, value| svg[key.to_s] = value }
  end

  def sanitize_svg(doc)
    sanitize(doc.to_html,
             tags: %w[svg path g circle rect line polyline polygon use defs clipPath title desc],
             attributes: %w[id class style viewBox fill stroke stroke-width stroke-linecap stroke-linejoin width height x y cx cy r transform d points xmlns xlink:href clip-path])
  end
end
