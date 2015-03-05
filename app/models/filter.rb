class Filter < ActiveRecord::Base
  # Associtations
  has_and_belongs_to_many :offers

  # Validations
  validates :name, uniqueness: true, presence: true
  validates :identifier, uniqueness: true, presence: true
end
