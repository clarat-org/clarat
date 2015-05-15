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

    if !cookies[:last_search_location].blank?
      @geoloc = JSON.parse(cookies[:last_search_location])['geoloc']
    # elsif (l = request.location) && !l.city.empty?
    #   @geoloc_string = l.city
    #   @geoloc = "#{l.latitude},#{l.longitude}"
    else
      @geoloc = I18n.t('conf.default_latlng')
    end
  end

  def geoloc_to_s geoloc = default_geolocation
    if !cookies[:last_search_location].blank?
      JSON.parse(cookies[:last_search_location])['query']
    elsif geoloc == I18n.t('conf.default_latlng')
      I18n.t('conf.default_location') # needed if that SearchLocation exists?
    elsif (search_location = SearchLocation.find_by_geoloc(geoloc))
      search_location.query
    # elsif @geoloc_string
    #   @geoloc_string
    else
      I18n.t('conf.default_location')
    end
  end

  # Modal with content block
  def modal_for selector, options = {}, &block
    render(
      partial: '/layouts/partials/modal',
      locals: { selector: selector, options: options, block: block }
    )
  end

  def full_title(page_title)
    base_title = 'clarat'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end
end
