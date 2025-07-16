# events_data = YAML.load_file("app/scripts/events.yml")
#
# puts events_data['events']
# Psych::DisallowedClass

# frozen_string_literal: true

module Melbourne
  class Event
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :uuid
    attribute :date, :date
    attribute :type
    attribute :venue
    attribute :talks

    def self.all # rubocop:disable Metrics/MethodLength
      @all ||= YAML.load_file(Engine.root.join("db", "data", "events.yml")).map do |event_data|
        event_data = event_data.with_indifferent_access
        Event.new(
          **event_data.slice(:uuid, :date, :type, :summary),
          venue: Venue.new(event_data.fetch("venue", {})),
          talks: event_data.fetch("talks", []).map do |talk|
            Talk.new(
              **talk.slice(:id, :title, :description, :video_url),
              speakers: talk.fetch(:speakers, []).map do |speaker|
                Speaker.new(**speaker)
              end
            )
          end
        )
      end
    end

    alias_attribute :id, :uuid
  end
end
