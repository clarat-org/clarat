class Location < ActiveRecord::Base
  has_paper_trail

  # Associtations
  belongs_to :organization, inverse_of: :locations
  belongs_to :federal_state, inverse_of: :locations
  has_many :offers, inverse_of: :location
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Validations
  validates :name, length: { maximum: 100 }
  validates :street, presence: true, format: /\A.+\d+.*\z/ # format: ensure digit for house number
  validates :zip, presence: true, length: { is: 5 }
  validates :city, presence: true

  validates :organization_id, presence: true
  validates :federal_state_id, presence: true

  # Methods

  def concat_address
    if name
      "#{name} (#{street} #{zip} #{city})"
    else
      "#{street} #{zip} #{city}"
    end
  end
end
