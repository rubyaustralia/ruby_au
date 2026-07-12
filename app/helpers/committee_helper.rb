module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end

  def presidents
    president_list = load_presidents

    grouped = group_presidents(president_list)

    grouped.sort! { |a, b| b[:start][-1] <=> a[:start][-1] }
  end

  def presidents_years
    presidents_data = presidents

    min_term = Date.parse(presidents_data[-1][:start][0])
    max_term = Date.parse(presidents_data[0][:end][-1])
    all_terms = max_term - min_term

    { min_term: min_term, max_term: max_term, all: all_terms }
  end

  # term calculation to be used in view
  # Offset: (the president start-date - min_term) / (max_term - min_term) * 100
  # Width(duration): (the president end-date - the president start-date)/ (max_term - min_term) * 100

  def president_terms(president)
    starts = president[:start]
    ends = president[:end]
    all_terms = presidents_years[:all]
    min = presidents_years[:min_term]

    starts.each_with_index.map do |start_date, index|
      start = Date.parse(start_date)
      end_date = Date.parse(ends[index])

      offset = (start - min) / all_terms * 100
      presidency = (end_date - start) / all_terms * 100

      { offset: offset.to_i, presidency: presidency.to_i }
    end
  end

  private

  def load_presidents
    current_committee = YAML.load_file Rails.root.join('config/data/committee.yml')
    previous_committee = YAML.load_file Rails.root.join('config/data/previous.yml')

    (current_committee + previous_committee)
      .filter { |member| president?(member) }
      .map { |p| { name: p['name'], start: to_array(p['start']), end: to_array(p['end']) } }
  end

  def group_presidents(president_list)
    grouped = []
    president_list.each do |record|
      other = grouped.find { |item| item[:name] == record[:name] }

      if other
        combine_records(other, record)
      else
        grouped << record
      end
    end
    grouped
  end

  def combine_records(other, record)
    other[:start].concat(record[:start]).sort!
    other[:end].concat(record[:end]).sort!
  end

  def president?(member)
    member['position'].downcase == 'president' ||
      member['position'].downcase.split(',').any? { |position| position.gsub(/\([^)]*\)/, '').strip == 'president' }
  end

  def to_array(term)
    term.is_a?(Array) ? term : [term]
  end
end
