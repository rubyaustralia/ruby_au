module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end

  def presidents
    current_committee = YAML.load_file Rails.root.join('config/data/committee.yml')
    previous_committee = YAML.load_file Rails.root.join('config/data/previous.yml')

    (current_committee + previous_committee)
      .filter { |member| president?(member) }
      .map { |p| { name: p['name'], start: to_array(p['start']), end: to_array(p['end']) } }
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
