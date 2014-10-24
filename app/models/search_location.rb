class SearchLocation < ActiveRecord::Base
  # Validations
  validates :query, presence: true, uniqueness: true
  validates :latitude, presence: true
  validates :longitude, presence: true

  before_validation :normalize_query
  before_save :set_geoloc

  # Geocoding
  geocoded_by :query
  before_validation :geocode

  # Methods

  def self.find_or_generate location_string
    location_string ||= 'Berlin'
    find_by_query(location_string) || create!(query: location_string)
  end

  private

    def normalize_query
      if self.query
        self.query = self.query.strip.titleize
      end
    end

    def set_geoloc
      self.geoloc = Geolocation.new(self).to_s
    end
end
