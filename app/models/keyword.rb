# Used internally by researchers to provide extra searchable keywords to offers.
class Keyword < ActiveRecord::Base
  # associtations
  has_and_belongs_to_many :offers, inverse_of: :keywords

  # Validations
  validates :name, length: { maximum: 80 }, uniqueness: true, presence: true
  validates :synonyms, length: { maximum: 400 }
end
