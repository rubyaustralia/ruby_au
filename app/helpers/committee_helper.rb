module CommitteeHelper
  def current_committee?
    user_signed_in? && current_user.committee?
  end

  def presidents
    current_committee = YAML.load_file Rails.root.join('config/data/committee.yml')
    previous_committee = YAML.load_file Rails.root.join('config/data/previous.yml')

    (current_committee + previous_committee)
      .filter { |member| member['position'].downcase == 'president' || member['position'].downcase.split(',').any? { |post| post.gsub(/\([^)]*\)/, '').strip == 'president' } }
      .map { |p| { name: p['name'], start: p['start'].is_a?(Array) ? p['start'] : [p['start']], end: p['end'].is_a?(Array) ? p['end'] : [p['end']] } }
  end
end
