# frozen_string_literal: true

# When running `rspec` without arguments, also run specs in sites/*/spec/.

to_run = RSpec.configuration.instance_variable_get(:@files_or_directories_to_run)
default_path = RSpec.configuration.default_path

if to_run == [default_path]
  Dir["sites/*/#{default_path}"].each do |site_spec_path|
    to_run << site_spec_path
  end

  RSpec.configuration.files_or_directories_to_run = to_run
end
