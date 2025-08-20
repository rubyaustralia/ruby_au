# frozen_string_literal: true

class MailingList
  LISTS = [
    "Ruby Retreat",
    "RubyConf AU",
    "RailsGirls"
  ].freeze

  attr_reader :name

  def self.all
    @all ||= LISTS.collect { |name| new name }
  end

  def self.each(...)
    all.each(...)
  end

  def initialize(name)
    @name = name
  end

  def api_id
    ENV["#{normalised_name.upcase}_LIST_ID"]
  end

  def normalised_name
    name.parameterize(separator: '_')
  end
end
