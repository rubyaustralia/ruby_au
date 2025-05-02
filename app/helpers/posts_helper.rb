def status_badge_class(status)
  status_classes = {
    draft: "bg-gray-100 text-gray-800",
    scheduled: "bg-blue-100 text-blue-800",
    published: "bg-green-100 text-green-800",
    archived: "bg-amber-100 text-amber-800"
  }

  status_classes[status.to_sym] || "bg-gray-100 text-gray-800"
end
