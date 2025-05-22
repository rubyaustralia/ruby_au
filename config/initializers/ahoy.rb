class Ahoy::Store < Ahoy::DatabaseStore
  def track_visit(data)
    data[:ip] = request.remote_ip if Ahoy.mask_ips
    super(data)
  end
end

Ahoy.visit_duration = 4.hours
Ahoy.visitor_duration = 2.years

# set to true for JavaScript tracking
Ahoy.api = true

# set to true for geocoding (and add the geocoder gem to your Gemfile)
# we recommend configuring local geocoding as well
# see https://github.com/ankane/ahoy#geocoding
Ahoy.geocode = false
