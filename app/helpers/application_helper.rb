# frozen_string_literal: true

module ApplicationHelper
  # Methods

  # # Get geolocation to prefill search form
  # # Prio 1: what the browser gives us if the user gave permission
  # # => handled by JavaScript (overrides the following)
  # # Prio 2: from cookie: last searched location
  # # Prio 3: geocoding from IP address
  # # Prio 4: Middle of Berlin
  # def default_geolocation
  #   return @geoloc if @geoloc
  #
  #   if !cookies[:last_search_location].blank?
  #     @geoloc = JSON.parse(cookies[:last_search_location])['geoloc']
  #   # elsif (l = request.location) && !l.city.empty?
  #   #   @geoloc_string = l.city
  #   #   @geoloc = "#{l.latitude},#{l.longitude}"
  #   else
  #     @geoloc = I18n.t('conf.default_latlng')
  #   end
  # end
  #
  # def geoloc_to_s geoloc = default_geolocation
  #   if !cookies[:last_search_location].blank?
  #     JSON.parse(cookies[:last_search_location])['query']
  #   elsif geoloc == I18n.t('conf.default_latlng')
  #     I18n.t('conf.default_location') # needed if that SearchLocation exists?
  #   elsif (search_location = SearchLocation.find_by_geoloc(geoloc))
  #     search_location.query
  #   # elsif @geoloc_string
  #   #   @geoloc_string
  #   else
  #     I18n.t('conf.default_location')
  #   end
  # end

  # Modal with content block
  def modal_for selector, options = {}, &block
    render(
      partial: '/layouts/partials/modal',
      locals: { selector: selector, options: options, block: block }
    )
  end

  def default_canonical_url
    section_regex = Regexp.new(Section::IDENTIFIER.join('|'))
    request.url.sub section_regex, Section::DEFAULT
  end

  # Get the not selected section. THis stops working as soon as we have more
  # than 2 sections.
  def inverse_section section
    section == 'family' ? 'refugees' : 'family'
  end
end
