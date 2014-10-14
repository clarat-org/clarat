class GeocodingWorker
  include Sidekiq::Worker

  def perform location_id
    location = Location.find(location_id)
    old_geoloc = Geolocation.new location

    # call geocoding gem (API)
    location.geocode
    location.save

    # update offer (_geoloc) index after coordinates changed
    if old_geoloc != Geolocation.new(location)
      location.offers.find_each(&:save)
    end
  end
end
