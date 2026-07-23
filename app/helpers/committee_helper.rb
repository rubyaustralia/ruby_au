module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end

  def presidents
    grouped_presidents = group_presidents(load_presidents)

    grouped_presidents.sort! { |a, b| b[:start][-1] <=> a[:start][-1] }
  end

  def presidents_years
    presidents_data = presidents

    min_term = Date.parse(presidents_data[-1][:start][0])
    max_term = Date.parse(presidents_data[0][:end][-1])

    { min_term: min_term, max_term: max_term }
  end

  def president_terms(president)
    starts = president[:start]
    ends = president[:end]
    all_terms = presidents_years[:max_term] - presidents_years[:min_term]
    min = presidents_years[:min_term]

    starts.map.with_index do |start_date, index|
      calc_each_term(start_date, ends[index], min, all_terms)
    end
  end

  def chart_years
    (presidents_years[:min_term].year..presidents_years[:max_term].year)
  end

  def year_length
    100.0 / chart_years.count
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

  def calc_each_term(start_date, end_date, min_term, all_terms)
    start_d = Date.parse(start_date)
    end_d = Date.parse(end_date)

    offset = (start_d - min_term) / all_terms * 100
    presidency = (end_d - start_d) / all_terms * 100

    { offset: offset.to_f, presidency: presidency.to_f }
  end
end
