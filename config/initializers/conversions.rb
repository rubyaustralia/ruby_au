# frozen_string_literal: true

# Time::DATE_FORMATS[:date_only] = '%A, %B %e %Y'

Time::DATE_FORMATS[:date_only] = lambda do |time|
  time.strftime("%A, %B #{time.day.ordinalize} %Y")
end

Time::DATE_FORMATS[:time_only] = '%I:%M %P'
