# frozen_string_literal: true

class MailingList
  LISTS = [
    # "Rails Camp",
    "RubyConf AU",
    "RailsGirls"
  ]

  attr_reader :name

  def self.all
    LISTS.collect { |name| new name }
  end

  def initialize(name)
    @name = name
  end

  def api_id
    ENV["#{normalised_name}_LIST_ID"]
  end

  private

  def normalised_name
    name.parameterize(separator: '_').upcase
  end
end
