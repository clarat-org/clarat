class SearchLocation < ActiveRecord::Base
  # Validations
  validates :query, presence: true, uniqueness: true
  validates :latitude, presence: true, on: :update
  validates :longitude, presence: true, on: :update

  # Geocoding
  geocoded_by :query
end
