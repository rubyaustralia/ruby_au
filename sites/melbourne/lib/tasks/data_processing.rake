# frozen_string_literal: true

namespace :melbourne do
  namespace :data do
    desc "fetch issues from melbourne-ruby"
    task :fetch_issues, [:repo_owner, :repo_name, :github_token] => :environment do
      raise unless Rails.env.development?

      repo_owner = args[:repo_owner] # rubyaustralia
      repo_name = args[:repo_name] # melbourne-ruby
      github_token = args[:github_token]

      fetcher = Melbourne::Github::IssueFetcher.new(
        github_token:,
        repo_owner:,
        repo_name:
      )

      result = fetcher.fetch_all

      no_milestone = result.delete("No Milestone")

      File.write(Melbourne::Engine.root.join("lib", "melbourne", "data", "output", "events", "raw", "issues.json"), JSON.pretty_generate(result.as_json))
      File.write(Melbourne::Engine.root.join("lib", "melbourne", "data", "output", "events", "raw", "issues-no-milestone.json"), JSON.pretty_generate(no_milestone.as_json))
    end

    desc "cleanup data for LLMs"
    task cleanup_data: :environment do
      result = Melbourne::Data::LLMPreparer.new(path: "#{Melbourne::Engine.root}/db/data/events/raw/issues.json").prepare

      File.write(
        Melbourne::Engine.root.join("lib", "melbourne", "data", "output", "events", "processed", "1_llm_meetups_data.json"),
        JSON.pretty_generate(result)
      )
    end

    desc "send request to LLM"
    task process_with_llms: :environment do
      caller = Melbourne::Data::LLMCaller.new(openai_api_key: ENV["OPENAI_API_KEY"])
      result = caller.call(path: File.read(Melbourne::Engine.root.join("lib", "melbourne", "data", "output", "events", "processed", "1_llm_meetups_data.json")))
      File.write(
        Melbourne::Engine.root.join("lib", "melbourne", "data", "output", "events", "processed", "2_llm_interpretation.json"),
        JSON.pretty_generate(result)
      )
    end

    desc "process issues; from json to yaml in event format"
    task process_into_domain_models: :environment do
      path = "#{Melbourne::Engine.root}/lib/melbourne/data/output/events/processed/2_llm_interpretation.json"
      processor = Melbourne::Data::DomainModelProcessor.new(path:)
      events = processor.process
      File.write(
        Melbourne::Engine.root.join("lib", "melbourne", "data", "output", "events", "processed", "3_data_in_app_domain.yml"),
        events.to_yaml
      )
    end
  end
end
