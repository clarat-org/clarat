class Keyword < ActiveRecord::Base
  # associtations
  belongs_to :offers

  # Validations
  validates :name, length: { maximum: 80 }, uniqueness: true, presence: true
  validates :synonyms, length: { maximum: 400 }

end
