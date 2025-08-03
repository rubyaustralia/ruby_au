module Admin::YoutubeAnalyticsHelper
  include YoutubeAnalyticsHelper

  # Admin-specific helper methods can go here
  def admin_export_button_class
    "w-full sm:w-auto bg-blue-600 text-white px-4 py-2 rounded-md text-sm font-medium hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-500"
  end

  def admin_metric_card_class
    "bg-white rounded-lg shadow-sm p-4 sm:p-6 border border-gray-200"
  end
end
