# == Schema Information
#
# Table name: events
#
#  id               :bigint           not null, primary key
#  end_time         :datetime
#  event_type       :string           not null
#  name             :string           not null
#  region           :string           not null
#  registration_url :string
#  slug             :string           not null
#  start_datetime   :datetime         not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  venue_id         :bigint
#
# Indexes
#
#  index_events_on_venue_id  (venue_id)
#
require 'rails_helper'

RSpec.describe DatabaseEvent, time_travel_to: "2026-10-13 12:00", type: :model do
  let(:two_months_ago) { Time.zone.local(2026, 8, 13, 18, 0) }
  let(:last_month)     { Time.zone.local(2026, 9, 13, 18, 0) }
  let(:today)          { Time.zone.local(2026, 10, 13, 0, 0) }
  let(:next_month)     { Time.zone.local(2026, 11, 13, 18, 0) }
  let(:two_months)     { Time.zone.local(2026, 12, 13, 18, 0) }

  describe '.today_or_in_the_future' do
    it "returns today and future events" do
      last_month_event = create(:database_event, :meetup, :melbourne, start_datetime: last_month)
      today_event      = create(:database_event, :meetup, :melbourne, start_datetime: today)
      next_month_event = create(:database_event, :meetup, :melbourne, start_datetime: next_month)

      expect(described_class.today_or_in_the_future).to include(next_month_event, today_event)
      expect(described_class.today_or_in_the_future).not_to include(last_month_event)
    end
  end

  describe ".all_by_date" do
    before do
      create(:database_event, :meetup, :melbourne, start_datetime: next_month)
      create(:database_event, :meetup, :melbourne, start_datetime: today)
    end

    it "returns all events, sorted by date descending" do
      events = described_class.all_by_date
      expect(events.count).to eq(2)
      expect(events.map(&:start_datetime)).to eq([next_month, today])
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      event = described_class.new(slug: "hello-123")
      expect(event.to_param).to eq("hello-123")
    end
  end

  describe "#date" do
    it "returns the date part of start_datetime in the app time zone" do
      event = described_class.new(start_datetime: Time.zone.local(2026, 10, 13, 18, 0))
      expect(event.date).to eq(Date.new(2026, 10, 13))
    end
  end

  describe "#start_time" do
    it "returns start_datetime" do
      event = described_class.new(start_datetime: Time.zone.local(2026, 10, 13, 18, 0))
      expect(event.start_time).to eq(Time.zone.local(2026, 10, 13, 18, 0))
    end
  end

  describe ".upcoming" do
    before do
      create(:database_event, :meetup, :melbourne, start_datetime: two_months)
      create(:database_event, :meetup, :melbourne, start_datetime: next_month)
      create(:database_event, :meetup, :melbourne, start_datetime: last_month)
      create(:database_event, :meetup, :melbourne, start_datetime: today)
    end

    it "returns all events scheduled for today and in the future" do
      expect(described_class.upcoming.map(&:start_datetime)).to eq([today, next_month, two_months])
    end

    context "when it is called with an amount" do
      it "returns that many events" do
        expect(described_class.upcoming(2).map(&:start_datetime)).to eq([today, next_month])
      end
    end

    context "when there are no upcoming events" do
      it "returns an empty array" do
        travel_to Time.zone.local(2027, 1, 13)
        expect(described_class.upcoming).to eq([])
      end
    end
  end

  describe ".past" do
    before do
      create(:database_event, :meetup, :melbourne, start_datetime: next_month)
      create(:database_event, :meetup, :melbourne, start_datetime: two_months_ago)
      create(:database_event, :meetup, :melbourne, start_datetime: last_month)
      create(:database_event, :meetup, :melbourne, start_datetime: today)
    end

    it "returns all events scheduled in the past" do
      expect(described_class.past.map(&:start_datetime)).to eq([last_month, two_months_ago])
    end

    context "when it is called with an amount" do
      it "returns that many events" do
        expect(described_class.past(1).map(&:start_datetime)).to eq([last_month])
      end
    end

    context "when there are no past events" do
      it "returns an empty array" do
        travel_to Time.zone.local(2026, 7, 13)
        expect(described_class.past).to eq([])
      end
    end
  end

  describe "#slug" do
    subject(:event) { FactoryBot.create(:database_event, :meetup, :melbourne, start_datetime: Time.zone.local(2026, 7, 21)) }

    it "generates a slug" do
      expect(event.slug).to eq("2026-07-21-ruby-melbourne-meetup")
    end

    context "when the region changes" do
      it "regenerates the slug" do
        event.region = :sydney
        event.save
        expect(event.slug).to eq("2026-07-21-ruby-sydney-meetup")
      end
    end

    context "when the event type changes" do
      it "regenerates the slug" do
        event.event_type = :conference
        event.save
        expect(event.slug).to eq("2026-07-21-ruby-melbourne-conference")
      end
    end

    context "when the date changes" do
      it "regenerates the slug" do
        event.start_datetime = Time.zone.local(2026, 8, 1)
        event.save
        expect(event.slug).to eq("2026-08-01-ruby-melbourne-meetup")
      end
    end
  end

  describe "#keywords" do
    it "generates keywords containing the region" do
      event = FactoryBot.create(:database_event, :meetup, :melbourne)
      expect(event.keywords).to eq("Events, Ruby, Rails, Melbourne")
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
