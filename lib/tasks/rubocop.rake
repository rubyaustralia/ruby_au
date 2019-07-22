# frozen_string_literal: true

# rubocop:disable Lint/HandleExceptions
begin
  require "rubocop/rake_task"

  desc "Run RuboCop"
  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
end
# rubocop:enable Lint/HandleExceptions
