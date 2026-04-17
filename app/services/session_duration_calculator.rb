class SessionDurationCalculator
  def call
    durations = calculate_durations
    return "0m" if durations.empty?

    avg_seconds = durations.sum / durations.size
    if avg_seconds < 1
      "< 1s"
    elsif avg_seconds < 60
      "#{avg_seconds.round(0)}s"
    else
      "#{(avg_seconds / 60).round(1)}m"
    end
  end

  private

  def calculate_durations
    visits_with_events.filter_map do |visit_id, last_event_time|
      # Avoid N+1 by using finding visits separately or using a better query
      # but for now let's just make it work correctly.
      visit = Ahoy::Visit.find_by(id: visit_id)
      duration = calculate_visit_duration(visit, last_event_time)
      duration if duration && duration > 0
    end
  end

  def visits_with_events
    Ahoy::Visit.where.not(started_at: nil)
               .where("started_at >= ?", 30.days.ago)
               .joins(:events)
               .group("ahoy_visits.id")
               .maximum('ahoy_events.time')
  end

  def find_visit(visit_id)
    Ahoy::Visit.find(visit_id)
  end

  def calculate_visit_duration(visit, last_event_time)
    return nil unless last_event_time && visit.started_at

    (last_event_time - visit.started_at).to_f # seconds
  end
end
