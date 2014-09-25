module ApplicationHelper
  # Methods

  # Get geolocation to prefill search form
  # Prio 1: what the browser gives us if the user gave permission
  # => handled by JavaScript (overrides the following)
  # Prio 2: from cookie: last searched location
  # Prio 3: geocoding from IP address
  # Prio 4: Middle of Berlin
  def default_geolocation
    cookies[:last_geolocation] || request.location || '52.520007,13.404954'
  end
end
