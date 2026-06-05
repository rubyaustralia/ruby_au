require 'rails_helper'

RSpec.describe CampaignsHelper, type: :helper do
  describe '#substitute_content' do
    let(:user) { create(:user, full_name: 'John Doe') }
    let(:membership) { create(:membership, user: user) }
    let(:event) { create(:rsvp_event, title: 'Ruby Meeting', happens_at: Time.zone.parse('2026-06-10 18:00')) }
    let(:rsvp) { create(:rsvp, membership: membership, rsvp_event: event) }

    it 'substitutes {{member.name}}' do
      content = 'Hello {{member.name}}'
      expect(helper.substitute_content(content, rsvp)).to include('Hello John Doe')
    end

    it 'substitutes {{event.title}}' do
      content = 'Welcome to {{event.title}}'
      expect(helper.substitute_content(content, rsvp)).to include('Welcome to Ruby Meeting')
    end

    it 'substitutes {{event.date}}' do
      content = 'Date: {{event.date}}'
      expect(helper.substitute_content(content, rsvp)).to include('Date: June 10, 2026')
    end

    it 'substitutes {{rsvp_links}}' do
      content = '{{rsvp_links}}'
      result = helper.substitute_content(content, rsvp)
      expect(result).to include('confirm')
      expect(result).to include('decline')
    end
  end
end
