require 'rails_helper'

RSpec.describe CampaignsHelper, type: :helper do
  describe '#substitute_content' do
    let(:membership) { instance_double(Membership, full_name: 'John Doe') }
    let(:event) { create(:rsvp_event, title: 'Ruby Meeting', happens_at: Time.zone.parse('2026-06-10 18:00')) }
    let(:rsvp) { instance_double(Rsvp, token: 'mock-token', membership: membership, rsvp_event: event) }

    it 'substitutes {{member.name}}' do
      content = 'Hello {{member.name}}'
      expect(helper.substitute_content(content, rsvp)).to include('Hello John Doe')
    end

    it 'substitutes {{ member.name }} (with spaces)' do
      content = 'Hello {{ member.name }}'
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
      expect(result).to include('http://test.host/rsvps/mock-token/confirm')
      expect(result).to include('http://test.host/rsvps/mock-token/decline')
    end

    it 'substitutes {{ rsvp_links }} (with spaces)' do
      content = '{{ rsvp_links }}'
      result = helper.substitute_content(content, rsvp)
      expect(result).to include('http://test.host/rsvps/mock-token/confirm')
      expect(result).to include('http://test.host/rsvps/mock-token/decline')
    end

    it 'substitutes {{unsubscribe_link}}' do
      content = '{{unsubscribe_link}}'
      expect(helper.substitute_content(content, rsvp)).to include('http://test.host/my/details/edit')
    end

    it 'substitutes {{ unsubscribe_link }} (with spaces)' do
      content = '{{ unsubscribe_link }}'
      expect(helper.substitute_content(content, rsvp)).to include('http://test.host/my/details/edit')
    end
  end
end
