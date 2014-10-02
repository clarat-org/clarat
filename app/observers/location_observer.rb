class LocationObserver < ActiveRecord::Observer
  # queue geocoding
  def after_save l
    if l.street_changed? || l.zip_changed? || l.city_changed? ||
       l.federal_state_id_changed?
      GeocodingWorker.perform_async l.id
    end
  end
end
