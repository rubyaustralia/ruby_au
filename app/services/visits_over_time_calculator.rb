class VisitsOverTimeCalculator
  def call
    visits_by_day = grouped_visits
    date_range.map { |date| build_day_data(date, visits_by_day) }
  end

  private

  def grouped_visits
    Ahoy::Visit.where("started_at >= ?", 30.days.ago)
               .group("DATE(started_at)")
               .count
  end

  def date_range
    30.days.ago.to_date..Date.current
  end

  def build_day_data(date, visits_by_day)
    {
      date: date.strftime("%b %d"),
      visits: visits_by_day[date.to_s] || 0
    }
  end
end
