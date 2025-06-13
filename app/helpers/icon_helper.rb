module IconHelper
  def lucide_icon(name, options = {})
    classes = options.delete(:class) || ""
    size = options.delete(:size) || 24

    content_tag(:span, "",
                class: "lucide-icon #{classes}",
                data: {
                  icon: name,
                  size: size
                }.merge(options))
  end
end
