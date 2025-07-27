# frozen_string_literal: true

module Melbourne
  class Event
    include ActiveModel::Model
    include ActiveModel::Attributes

    attribute :uuid
    attribute :date, :date
    attribute :name
    attribute :description
    attribute :slug
    attribute :type
    attribute :venue
    attribute :talks

    validates :uuid, presence: true
    validates :date, presence: true
    validates :name, presence: true
    validates :description, presence: true
    validates :slug, presence: true
    validates :type, presence: true
    validates :venue, presence: true
    validates :talks, presence: true

    def self.all
      @all ||= events_from_yaml_db.map do |event_data|
        event_data = event_data.with_indifferent_access
        Event.new(
          **event_data.slice(:uuid, :date, :type, :description, :name, :slug),
          venue: Venue.new(event_data.fetch("venue", {})),
          talks: build_talks(event_data.fetch("talks", []))
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

    def schema
      Schema.new(self).to_h
    end

    def open_graph_metadata
      OpenGraphMetadata.new(self).to_meta_tags
    end

    def self.build_talks(talks)
      talks.map do |talk|
        Talk.new(
          **talk.slice(:uuid, :title, :description, :video_url),
          speakers: build_speakers(talk.fetch(:speakers, [])),
        )
      end
    end

    def self.build_speakers(speakers)
      speakers.map { Speaker.new(**it) }
    end

    def self.events_from_yaml_db
      YAML.load_file(Engine.root.join("db", "data", "events.yml"))
    end
  end
end
