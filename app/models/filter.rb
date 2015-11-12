# STI parent model for different kinds of filters. Children located in the
# filters subfolder.
class Filter < ActiveRecord::Base
  # Associtations
  has_and_belongs_to_many :offers

  # Validations
  validates :name, uniqueness: true, presence: true
  validates :identifier, uniqueness: true, presence: true
end
