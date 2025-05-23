class DeviceBreakdownCalculator
  BACKGROUND_COLORS = [
    '#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6'
  ].freeze

  def call
    device_counts = calculate_device_counts
    normalize_device_counts(device_counts)
    build_chart_data(device_counts)
  end

  private

  def calculate_device_counts
    Ahoy::Visit.where("started_at >= ?", 30.days.ago)
               .group(:device_type)
               .count
  end

  def normalize_device_counts(device_counts)
    device_counts["Unknown"] = device_counts.delete(nil) if device_counts[nil]
  end

  def build_chart_data(device_counts)
    {
      labels: device_counts.keys.map(&:titleize),
      data: device_counts.values,
      backgroundColor: BACKGROUND_COLORS
    }
  end
end
