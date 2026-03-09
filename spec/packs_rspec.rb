# frozen_string_literal: true

# Replaces packs-rails RSpec integration.
# When running `rspec` without arguments, also run specs in packs/*/spec/.

to_run = RSpec.configuration.instance_variable_get(:@files_or_directories_to_run)
default_path = RSpec.configuration.default_path

if to_run == [default_path]
  Dir["packs/*/#{default_path}"].each do |pack_spec_path|
    to_run << pack_spec_path
  end

  RSpec.configuration.files_or_directories_to_run = to_run
end
