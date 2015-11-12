class GeocodingWorker
  include Sidekiq::Worker

  def perform location_id
    loc = Location.find(location_id)
    old_geoloc = Geolocation.new loc

    # call geocoding gem (API)
    loc.geocode
    loc.save

    # ensure location now has coordinates
    raise 'Geocoding failed' unless loc.latitude && loc.longitude

    # update offer (_geoloc) index after coordinates changed
    loc.offers.find_each(&:save) if old_geoloc != Geolocation.new(loc)
  end
end
