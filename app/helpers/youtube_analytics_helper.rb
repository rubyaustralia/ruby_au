module YoutubeAnalyticsHelper
  def format_number(number)
    return '0' if number.nil?

    if number >= 1_000_000
      "#{(number / 1_000_000.0).round(1)}M"
    elsif number >= 1_000
      "#{(number / 1_000.0).round(1)}K"
    else
      number.to_s
    end
  end

  def format_percentage(percentage)
    return '0%' if percentage.nil?

    if percentage > 0
      "+#{percentage}%"
    else
      "#{percentage}%"
    end
  end

  def percentage_color_class(percentage)
    return 'text-gray-500' if percentage.nil?

    if percentage > 0
      'text-green-600'
    elsif percentage < 0
      'text-red-600'
    else
      'text-gray-500'
    end
  end

  def youtube_metric_trend_icon(percentage)
    return '' if percentage.nil?

    if percentage > 0
      '<svg class="w-4 h-4 text-green-600 inline ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 11l5-5m0 0l5 5m-5-5v12"></path>
      </svg>'.html_safe
    elsif percentage < 0
      '<svg class="w-4 h-4 text-red-600 inline ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 13l-5 5m0 0l-5-5m5 5V6"></path>
      </svg>'.html_safe
    else
      '<svg class="w-4 h-4 text-gray-500 inline ml-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
      </svg>'.html_safe
    end
  end
end
