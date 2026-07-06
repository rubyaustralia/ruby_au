# == Schema Information
#
# Table name: events
#
#  id               :bigint           not null, primary key
#  date             :date             not null
#  description      :text             not null
#  end_time         :datetime
#  event_type       :string           not null
#  name             :string           not null
#  region           :string           not null
#  registration_url :string
#  slug             :string           not null
#  start_time       :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  venue_id         :bigint
#
# Indexes
#
#  index_events_on_venue_id  (venue_id)
#
require 'rails_helper'

RSpec.describe DatabaseEvent, type: :model do
  describe '.today_or_in_the_future' do
    let(:last_month_event) { create(:database_event, :meetup, :melbourne, date: 1.month.ago) }
    let(:today_event)      { create(:database_event, :meetup, :melbourne, date: Date.current) }
    let(:next_month_event) { create(:database_event, :meetup, :melbourne, date: 1.month.from_now) }

    it "returns today and future events" do
      expect(described_class.today_or_in_the_future).to include(next_month_event)
      expect(described_class.today_or_in_the_future).to include(today_event)
      expect(described_class.today_or_in_the_future).not_to include(last_month_event)
    end
  end

  describe ".all_by_date" do
    before do
      create(:database_event, :meetup, :melbourne, date: 1.month.from_now)
      create(:database_event, :meetup, :melbourne, date: Date.current)
    end

    it "returns all events, sorted by date descending" do
      events = described_class.all_by_date
      expect(events.count).to eq(2)
      expect(events[0].date).to eq(1.month.from_now.to_date)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      event = described_class.new(slug: "hello-123")
      expect(event.to_param).to eq("hello-123")
    end
  end

  describe ".upcoming" do
    before do
      create(:database_event, :meetup, :melbourne, date: 2.months.from_now)
      create(:database_event, :meetup, :melbourne, date: 1.month.from_now)
      create(:database_event, :meetup, :melbourne, date: 1.month.ago)
      create(:database_event, :meetup, :melbourne, date: Date.current)
    end

    it "returns all events scheduled for today and in the future" do
      expect(described_class.upcoming.map(&:date)).to eq(
        [
          Date.current,
          1.month.from_now.to_date,
          2.months.from_now.to_date
        ]
      )
    end

    context "when it is called with an amount" do
      it "returns that many events" do
        expect(described_class.upcoming(2).map(&:date)).to eq(
          [
            Date.current,
            1.month.from_now.to_date
          ]
        )
      end
    end

    context "when there are no upcoming events" do
      it "returns an empty array" do
        travel_to 3.months.from_now do
          expect(described_class.upcoming).to eq([])
        end
      end
    end
  end

  describe ".past" do
    before do
      create(:database_event, :meetup, :melbourne, date: 1.month.from_now)
      create(:database_event, :meetup, :melbourne, date: 2.months.ago)
      create(:database_event, :meetup, :melbourne, date: 1.month.ago)
      create(:database_event, :meetup, :melbourne, date: Date.current)
    end

    it "returns all events scheduled in the past" do
      expect(described_class.past.map(&:date)).to eq(
        [
          1.month.ago.to_date,
          2.months.ago.to_date
        ]
      )
    end

    context "when it is called with an amount" do
      it "returns that many events" do
        expect(described_class.past(1).map(&:date)).to eq(
          [
            1.month.ago.to_date
          ]
        )
      end
    end

    context "when there are no past events" do
      it "returns an empty array" do
        travel_to 3.months.ago do
          expect(described_class.past).to eq([])
        end
      end
    end
  end

  describe "DatabaseEvent" do
    it "differs from site Melbourne::Event" do
      events = Melbourne::Event.all
      expect(events).to be_an(Array)

      first_event = events.first
      expect(first_event).to be_a(Melbourne::Event)
      expect(first_event.venue).to be_a(Melbourne::Event::Venue)
      expect(first_event.talks.first).to be_a(Melbourne::Event::Talk)
      expect(first_event.talks.first.speakers.first).to be_a(Melbourne::Event::Speaker)

      database_event_with_talks
      events = described_class.all_by_date
      expect(events).to be_an(ActiveRecord::Relation)

      first_event = events.first
      expect(first_event).to be_a(described_class)
      expect(first_event.venue).to be_a(Venue)
      expect(first_event.talks.first).to be_a(Talk)
      expect(first_event.talks.first.speakers).to be_a(String)
    end
  end
end
