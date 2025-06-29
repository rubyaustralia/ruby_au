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

    def self.all
      @all ||= YAML.load_file(Engine.root.join("db", "data", "events.yml")).map do |event_data|
        event_data = event_data.with_indifferent_access
        Event.new(
          **event_data.slice(:uuid, :date, :type),
          venue: Venue.new(event_data.fetch("venue", {})),
          talks: event_data.fetch("talks", []).map { Talk.new(**it.slice(:id, :title, :description, :video_url), speaker: Speaker.new(it.fetch(:speaker, {}))) }
        )
      end
    end

    alias_attribute :id, :uuid
  end
end
