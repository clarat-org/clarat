class LocationObserver < ActiveRecord::Observer

  # update offer (_geoloc) index after coordinates changed
  def after_save
    if latitude_changed? || longitude_changed?
      location.offers.find_each(&:save)
    end
  end
end