# frozen_string_literal: true

require "markdown_handler"

module ApplicationHelper
  TIME_ZONES = {
    "Melbourne" => "NSW, Victoria, Tasmania, ACT",
    "Brisbane" => "Queensland",
    "Adelaide" => "South Australia",
    "Darwin" => "Northern Territory",
    "Perth" => "Western Australia"
  }.freeze

  def committee
    YAML.load_file Rails.root.join('config/data/committee.yml')
  end

  def document_markdown_to_html(name)
    input = File.read Rails.root.join("app/documents/#{name}.markdown")

    tag.div markdown_to_html(input), class: 'markdown'
  end

  def link_to_external(name = nil, options = nil, html_options = {})
    svg = inline_svg_tag "external-link.svg", height: 12
    html_options[:target] ||= "_blank"
    html_options[:rel]    ||= "external"

    link_to safe_join([name, svg]), options, html_options
  end

  def markdown_to_html(raw)
    return nil if raw.nil?

    MarkdownHandler.render(raw)
  end

  def password_errors?(user)
    user.errors.keys.grep(/password/).any?
  end

  def previous
    YAML.load_file Rails.root.join('config/data/previous.yml')
  end

  def time_zones
    TIME_ZONES
  end
end
