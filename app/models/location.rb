class Location < ActiveRecord::Base
  has_paper_trail

  # Associtations
  belongs_to :organization, inverse_of: :locations
  belongs_to :federal_state, inverse_of: :locations
  has_many :offers, inverse_of: :location
  has_many :websites, as: :linkable, inverse_of: :linkable

  # Validations
  validates :name, length: { maximum: 100 }
  validates :street, presence: true, format: /\A.+\d+.*\z/ # format: ensure digit for house number
  validates :zip, presence: true, length: { is: 5 }
  validates :city, presence: true

  # Methods

  def concat_address
    "#{street} #{zip} #{city}"
  end
end
