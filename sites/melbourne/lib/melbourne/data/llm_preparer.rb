# frozen_string_literal: true

module Melbourne
  module Data
    class LLMPreparer
      def initialize(path:)
        @json_contents = JSON.parse(File.read(path))
      end

      def prepare # rubocop:disable Metrics/MethodLength
        json_contents.map do |date, talks|
          date = Date.parse(date).end_of_month.prev_occurring(:thursday)
          {
            date: date.to_s,
            talks: talks.map do |talk|
              {
                id: talk["id"],
                title: talk["title"],
                description: talk["description"],
                comments: talk["comments"].map do |comment|
                  {
                    github_username: comment["user"],
                    body: comment["body"],
                  }
                end
              }
            end
          }
        end
      end

      private

      attr_reader :json_contents
    end
  end
end
