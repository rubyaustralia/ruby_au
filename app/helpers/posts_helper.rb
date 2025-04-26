module PostsHelper
  def status_badge_class(status)
    case status.to_sym
    when :draft
      "bg-gray-100 text-gray-800"
    when :scheduled
      "bg-blue-100 text-blue-800"
    when :published
      "bg-green-100 text-green-800"
    when :archived
      "bg-amber-100 text-amber-800"
    else
      "bg-gray-100 text-gray-800"
    end
  end
end
