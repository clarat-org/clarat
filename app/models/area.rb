# Bounding Box around an area that a non-personal offer provides service to.
class Area < ActiveRecord::Base
  # Associations
  has_many :offers, inverse_of: :area

  # Validations
  validates :name, presence: true, uniqueness: true
  validates :minlat, presence: true, numericality: {
    only_float: true,
    less_than: ->(area) { area.maxlat }
  }
  validates :maxlat, presence: true, numericality: {
    only_float: true,
    greater_than: ->(area) { area.minlat }
  }
  validates :minlong, presence: true, numericality: {
    only_float: true,
    less_than: ->(area) { area.maxlong }
  }
  validates :maxlong, presence: true, numericality: {
    only_float: true,
    greater_than: ->(area) { area.minlong }
  }
end
