module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end

  def presidents
    current_committee = YAML.load_file Rails.root.join('config/data/committee.yml')
    previous_committee = YAML.load_file Rails.root.join('config/data/previous.yml')

    president_list = (current_committee + previous_committee)
                     .filter { |member| president?(member) }
                     .map { |p| { name: p['name'], start: to_array(p['start']), end: to_array(p['end']) } }

    grouped = []
    president_list.each do |record|
      multiple = grouped.find { |item| item[:name] == record[:name] }

      if multiple
        multiple[:start].concat(record[:start]).sort!
        multiple[:end].concat(record[:end]).sort!
        president_list.delete(record)
      else
        grouped << record
      end
    end

    president_list.sort! { |a, b| b[:start][-1] <=> a[:start][-1] }
  end

  private

  def president?(member)
    member['position'].downcase == 'president' ||
      member['position'].downcase.split(',').any? { |position| position.gsub(/\([^)]*\)/, '').strip == 'president' }
  end

  def to_array(term)
    term.is_a?(Array) ? term : [term]
  end
end
