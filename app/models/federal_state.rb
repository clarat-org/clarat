class FederalState < ActiveRecord::Base
  # Associtations
  has_many :locations, inverse_of: :federal_state

  # Validations
  validates :name, uniqueness: true, presence: true
end
