module SvgHelper
  def vite_inline_svg(name, options = {})
    svg_file_path = Rails.root.join('app', 'frontend', 'images', name.to_s)

    if File.exist?(svg_file_path)
      svg_content = File.read(svg_file_path)

      attributes = options.map { |k, v| "#{k}=\"#{v}\"" }.join(' ')
      svg_content.sub!(/^<svg/, "<svg #{attributes}")

      raw(svg_content)
    else
      "SVG not found: #{name}"
    end
  end
end
