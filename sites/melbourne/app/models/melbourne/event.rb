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
    attribute :summary
    attribute :slug
    attribute :type
    attribute :venue
    attribute :talks

    def self.all # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      @all ||= YAML.load_file(Engine.root.join("db", "data", "events.yml")).map do |event_data|
        event_data = event_data.with_indifferent_access
        Event.new(
          **event_data.slice(:uuid, :date, :type, :summary, :slug),
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
      end.sort_by(&:date).reverse!
    end

    def self.find_by_slug(slug)
      all.find { it.slug == slug }
    end

    alias_attribute :id, :uuid

    def to_param
      slug
    end

    def name
      slug.split("-", 4).last.underscore.humanize
    end

    def schema
      Schema.new(self)
    end
  end
end
