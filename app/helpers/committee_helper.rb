module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end

  def presidents
    president_list = load_presidents

    group_presidents(president_list)

    president_list.sort! { |a, b| b[:start][-1] <=> a[:start][-1] }
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
        president_list.delete(record)
      else
        grouped << record
      end
    end
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
