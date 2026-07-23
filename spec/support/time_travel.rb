# frozen_string_literal: true

# Freeze the clock for an example (or group) by tagging it with a target time:
#
#   RSpec.describe Thing, time_travel_to: "2024-12-01" do ... end
#
# The whole example runs with `Time.current` pinned to that instant (parsed in
# the app zone), then the clock is restored. Useful when a spec needs a fixed,
# known date — deterministic ICS output, a rendered date string — without that
# literal rotting into the past and tripping future-dated validations.
RSpec.configure do |config|
  config.around(:each, :time_travel_to) do |example|
    travel_to(Time.zone.parse(example.metadata[:time_travel_to])) { example.run }
  end
end
