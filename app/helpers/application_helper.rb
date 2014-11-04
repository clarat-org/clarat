module ApplicationHelper
  # Methods

  # Get geolocation to prefill search form
  # Prio 1: what the browser gives us if the user gave permission
  # => handled by JavaScript (overrides the following)
  # Prio 2: from cookie: last searched location
  # Prio 3: geocoding from IP address
  # Prio 4: Middle of Berlin
  def default_geolocation
    return @geoloc if @geoloc

    if cookies[:last_geolocation]
      @geoloc = cookies[:last_geolocation]
    elsif (l = request.location) && !l.city.empty?
      @geoloc_string = l.city
      @geoloc = "#{l.latitude},#{l.longitude}"
    else
      @geoloc = '52.520007,13.404954'
    end
  end

  def geoloc_to_s geoloc = default_geolocation
    if geoloc == '52.520007,13.404954'
      'Berlin'
    elsif (search_location = SearchLocation.find_by_geoloc(geoloc))
      search_location.query
    elsif @geoloc_string
      @geoloc_string
    else
      'Berlin'
    end
  end
end
