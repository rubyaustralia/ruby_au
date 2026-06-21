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
  describe ".all_by_date" do
    it "returns all events, sorted by date descending" do
      FactoryBot.create(:database_event, :meetup, :melbourne)
      FactoryBot.create(:database_event, :conference, :sydney)

      events = described_class.all_by_date
      expect(events).to respond_to(:each)
      expect(events.count).to eq(2)
    end
  end

  describe "#to_param" do
    it "returns the slug" do
      event = described_class.new(slug: "hello-123")
      expect(event.to_param).to eq("hello-123")
    end
  end

  describe ".upcoming" do
    it "returns all events scheduled for today and in the future" do
      allow(described_class).to \
        receive(:all).and_return(
          [
            described_class.new(date: 1.day.ago),
            described_class.new(date: Time.zone.today),
            described_class.new(date: 2.days.from_now)
          ]
        )

      expect(described_class.upcoming.map(&:date)).to eq(
        [
          Time.zone.today,
          2.days.from_now.to_date
        ]
      )
    end

    context "when it is called with an amount" do
      it "returns that many events" do
        allow(described_class).to \
          receive(:all).and_return(
            [
              described_class.new(date: 1.day.from_now),
              described_class.new(date: 2.days.from_now),
              described_class.new(date: 3.days.from_now)
            ]
          )

        expect(described_class.upcoming(2).map(&:date)).to eq(
          [
            1.day.from_now.to_date,
            2.days.from_now.to_date
          ]
        )
      end
    end

    context "when there are no upcoming events" do
      it "returns an empty array" do
        allow(described_class).to \
          receive(:all).and_return(
            [
              described_class.new(date: 1.day.ago)
            ]
          )

        expect(described_class.upcoming).to eq([])
      end
    end
  end

  describe ".past" do
    it "returns all events scheduled in the past" do
      allow(described_class).to \
        receive(:all).and_return(
          [
            described_class.new(date: 2.days.ago),
            described_class.new(date: 1.day.ago),
            described_class.new(date: Time.zone.today)
          ]
        )

      expect(described_class.past.map(&:date)).to eq(
        [
          1.day.ago.to_date,
          2.days.ago.to_date
        ]
      )
    end

    context "when it is called with an amount" do
      it "returns that many events" do
        allow(described_class).to \
          receive(:all).and_return(
            [
              described_class.new(date: 3.days.ago),
              described_class.new(date: 2.days.ago),
              described_class.new(date: 1.day.ago)
            ]
          )

        expect(described_class.past(2).map(&:date)).to eq(
          [
            1.day.ago.to_date,
            2.days.ago.to_date
          ]
        )
      end
    end

    context "when there are no past events" do
      it "returns an empty array" do
        allow(described_class).to \
          receive(:all).and_return(
            [
              described_class.new(date: Time.zone.today)
            ]
          )

        expect(described_class.past).to eq([])
      end
    end
  end

  describe ".last" do
    it "returns the last event by default" do
      events = [
        described_class.new(date: 3.days.ago),
        described_class.new(date: 2.days.ago),
        described_class.new(date: 1.day.ago)
      ]
      allow(described_class).to receive(:all).and_return(events)

      result = described_class.last
      expect(result).to eq([events.last])
    end

    it "returns the last n events in reverse order" do
      events = [
        described_class.new(date: 3.days.ago),
        described_class.new(date: 2.days.ago),
        described_class.new(date: 1.day.ago)
      ]
      allow(described_class).to receive(:all).and_return(events)

      result = described_class.last(2)
      expect(result).to eq([events.last, events[-2]])
    end
  end

  describe "#today_or_in_the_future?" do
    it "returns true for today's events" do
      event = described_class.new(date: Date.current)
      expect(event.today_or_in_the_future?).to be(true)
    end

    it "returns true for future events" do
      event = described_class.new(date: 1.day.from_now)
      expect(event.today_or_in_the_future?).to be(true)
    end

    it "returns false for past events" do
      event = described_class.new(date: 1.day.ago)
      expect(event.today_or_in_the_future?).to be(false)
    end
  end

  describe "#slug" do
    subject(:event) { FactoryBot.create(:database_event, :meetup, :melbourne, date: Time.zone.local(2026, 7, 21)) }

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
        event.date = Time.zone.local(2026, 8, 1)
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
