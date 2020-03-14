# frozen_string_literal: true

# rubocop:disable Lint/SuppressedException
begin
  require "rubocop/rake_task"

  desc "Run RuboCop"
  RuboCop::RakeTask.new(:rubocop)
rescue LoadError
end
# rubocop:enable Lint/SuppressedException
