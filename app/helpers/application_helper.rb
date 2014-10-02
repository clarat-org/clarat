module ApplicationHelper
  # Methods

  # Get geolocation to prefill search form
  # Prio 1: what the browser gives us if the user gave permission
  # => handled by JavaScript (overrides the following)
  # Prio 2: from cookie: last searched location
  # Prio 3: geocoding from IP address
  # Prio 4: Middle of Berlin
  def default_geolocation
    @geoloc ||= cookies[:last_geolocation]
    @geoloc ||= (l = request.location) ? "#{l.latitude},#{l.longitude}" : nil # TODO: does this ever return nil?
    @geoloc ||= '52.520007,13.404954'
  end

  def geoloc_to_s geoloc = default_geolocation
    if geoloc == '52.520007,13.404954'
      'Berlin'
    elsif (search_location = SearchLocation.find_by_geoloc(geoloc))
      search_location.query
    else
      raise "TODO: Reverse Geocoding (nothing found for: #{geoloc})"
    end
  end
end
