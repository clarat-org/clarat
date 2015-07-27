# Normalization of (German) federal states.
class FederalState < ActiveRecord::Base
  # Associations
  has_many :locations, inverse_of: :federal_state

  # Validations
  validates :name, uniqueness: true, presence: true
end
