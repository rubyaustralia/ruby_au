# frozen_string_literal: true

module Melbourne
  module Github
    class IssueFetcher
      def initialize(github_token:, repo_owner:, repo_name:)
        @github_token = github_token
        @repo_owner = repo_owner
        @repo_name = repo_name
      end

      def fetch_all
        issues = fetch_issues
        group_by_milestone(issues)
      end

      private

      attr_reader :github_token, :repo_owner, :repo_name

      def fetch_issues # rubocop:disable Metrics/AbcSize
        uri = URI("https://api.github.com/repos/#{repo_owner}/#{repo_name}/issues")
        uri.query = URI.encode_www_form(state: 'all', per_page: 100)

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "token #{github_token}"
        request['Accept'] = 'application/vnd.github.v3+json'

        response = http.request(request)

        raise "Error fetching issues: #{response.code} - #{response.body}" unless response.code == '200'

        JSON.parse(response.body)
      end

      def fetch_comments(issue_number) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        uri = URI("https://api.github.com/repos/#{repo_owner}/#{repo_name}/issues/#{issue_number}/comments")

        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = "token #{github_token}"
        request['Accept'] = 'application/vnd.github.v3+json'

        response = http.request(request)

        raise "Error fetching comments for issue #{issue_number}: #{response.code}" unless response.code == '200'

        comments = JSON.parse(response.body)
        comments.map do |comment|
          {
            id: comment['id'],
            user: comment['user']['login'],
            body: comment['body'],
            created_at: comment['created_at'],
            updated_at: comment['updated_at']
          }
        end
      end

      def group_by_milestone(issues) # rubocop:disable Metrics/MethodLength
        grouped = {}

        issues.each do |issue|
          milestone_name = issue['milestone'] ? issue['milestone']['title'] : 'No Milestone'

          grouped[milestone_name] ||= []

          comments = fetch_comments(issue['number'])

          grouped[milestone_name] << {
            id: issue['id'],
            number: issue['number'],
            title: issue['title'],
            description: issue['body'],
            state: issue['state'],
            created_at: issue['created_at'],
            updated_at: issue['updated_at'],
            url: issue['html_url'],
            comments: comments
          }
        end

        grouped
      end
    end
  end
end
