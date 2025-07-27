# frozen_string_literal: true

module Melbourne
  module Data
    class LLMCaller # rubocop:disable Metrics/ClassLength:
      def initialize(openai_api_key:)
        # Define the request URL
        uri = URI('https://api.openai.com/v1/responses')

        # Create HTTP client
        @http = Net::HTTP.new(uri.host, uri.port)
        @http.use_ssl = true

        # Create the request
        @request = Net::HTTP::Post.new(uri)
        @request['Content-Type'] = 'application/json'
        @request['Authorization'] = "Bearer #{openai_api_key}"
      end

      def call(path:)
        meetups = JSON.parse(path)
        meetups.map do |meetup|
          perform_request(meetup)
        end
      end

      private

      attr_reader :request, :http

      def perform_request(meetup)
        request.body = request_body(meetup).to_json

        response = http.request(request)
        parsed_response = JSON.parse(response.body)

        JSON.parse(parsed_response.fetch("output").first.fetch("content").first.fetch("text"))
      end

      def request_body(event_json) # rubocop:disable Metrics/MethodLength
        {
          "model" => "gpt-4.1",
          "input" => [
            {
              "role" => "user",
              "content": [
                {
                  "type" => "input_text",
                  "text" => "#{base_prompt} ```json #{event_json} ```"
                }
              ]
            }
          ],
          "text" => {
            "format" => {
              "type" => "json_schema",
              "name" => "event_schema",
              "strict" => true,
              "schema" => {
                "type" => "object",
                "properties" => {
                  "date" => {
                    "type" => "string",
                    "description" => "The date of the event in YYYY-MM-DD format",
                    "pattern" => "^\\d{4}-\\d{2}-\\d{2}$"
                  },
                  "name" => {
                    "type" => "string",
                    "name" => "The name of the event. 60ch max. Includes talks topics and speakers",
                  },
                  "description" => {
                    "type" => "string",
                    "description" => "A short description of the speakers and the topics.",
                  },
                  "slug" => {
                    "type" => "string",
                    "description" => "The slug of the event in YYYY-MM-DD-short-description format",
                  },
                  "talks" => {
                    "type" => "array",
                    "description" => "List of talks to be delivered at the event.",
                    "items" => {
                      "type" => "object",
                      "properties" => {
                        "title" => {
                          "type" => "string",
                          "description" => "Title of the talk."
                        },
                        "description" => {
                          "type" => "string",
                          "description" => "Description of the talk."
                        },
                        "speakers" => {
                          "type" => "array",
                          "description" => "List of speakers for the talk.",
                          "items" => {
                            "type" => "object",
                            "properties" => {
                              "name" => {
                                "type" => "string",
                                "description" => "Name of the speaker."
                              },
                              "contact_details" => {
                                "type" => "object",
                                "properties" => {
                                  "github_username" => {
                                    "type" => %w[string null],
                                    "description" => "GitHub username of the speaker."
                                  },
                                  "x_handle" => {
                                    "type" => %w[string null],
                                    "description" => "X social media handle of the speaker."
                                  },
                                  "linkedin_handle" => {
                                    "type" => %w[string null],
                                    "description" => "LinkedIn handle of the speaker."
                                  },
                                  "bluesky_handle" => {
                                    "type" => %w[string null],
                                    "description" => "Bluesky handle of the speaker."
                                  },
                                  "mastodon_handle" => {
                                    "type" => %w[string null],
                                    "description" => "Mastodon handle of the speaker."
                                  },
                                  "website" => {
                                    "type" => %w[string null],
                                    "description" => "Personal website of the speaker."
                                  }
                                },
                                "required" => %w[
                                  github_username
                                  x_handle
                                  linkedin_handle
                                  bluesky_handle
                                  mastodon_handle
                                  website
                                ],
                                "additionalProperties" => false
                              }
                            },
                            "required" => %w[name contact_details],
                            "additionalProperties" => false
                          }
                        }
                      },
                      "required" => %w[title description speakers],
                      "additionalProperties" => false
                    }
                  }
                },
                "required" => %w[date talks name description slug],
                "additionalProperties" => false
              }
            }
          },
          "reasoning" => {},
          "tools" => [],
          "temperature" => 1,
          "max_output_tokens" => 2048,
          "top_p" => 1,
          "store" => true
        }
      end

      def base_prompt
        File.read(Melbourne::Engine.root.join("lib", "melbourne", "data", "prompt.md"))
      end
    end
  end
end
