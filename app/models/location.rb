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
  validates :fax, format: /\A\d*\z/, length: { maximum: 32 }
  validates :telephone, format: /\A\d*\z/, length: { maximum: 32 }
  validates :second_telephone, format: /\A\d*\z/, length: { maximum: 32 }

  validates :organization_id, presence: true
  validates :federal_state_id, presence: true

  # Geocoding
  geocoded_by :full_address
  after_validation :geocode, unless: :latitude # TEMPORARY! Use async processing (also remember address might have changed)

  # Methods

  delegate :name, to: :federal_state, prefix: true

  def concat_address
    if name and !name.empty?
      "#{name} (#{street} #{zip} #{city})"
    else
      "#{street} #{zip} #{city}"
    end
  end

  private

    def full_address
      "#{street}, #{zip} #{city} #{federal_state_name}"
    end
end
