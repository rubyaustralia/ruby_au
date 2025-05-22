class SessionDurationCalculator
  def call
    durations = calculate_durations
    return "0m" if durations.empty?

    avg_minutes = durations.sum / durations.size
    "#{avg_minutes.round(1)}m"
  end

  private

  def calculate_durations
    visits_with_events.filter_map do |visit_id, last_event_time|
      visit = find_visit(visit_id)
      calculate_visit_duration(visit, last_event_time)
    end
  end

  def visits_with_events
    Ahoy::Visit.where.not(started_at: nil)
               .where("started_at >= ?", 30.days.ago)
               .joins(:events)
               .group(:id)
               .maximum('ahoy_events.time')
  end

  def find_visit(visit_id)
    Ahoy::Visit.find(visit_id)
  end

  def calculate_visit_duration(visit, last_event_time)
    return nil unless last_event_time && visit.started_at

    ((last_event_time - visit.started_at) / 60).round(2) # minutes
  end
end
