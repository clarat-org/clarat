# One of the main models: A location that an organization uses to provide a
# local offer. Has geocoordinates to make associated offers locally searchable.
class Location < ActiveRecord::Base
  has_paper_trail

  # Associtations
  belongs_to :organization, inverse_of: :locations, counter_cache: true
  belongs_to :federal_state, inverse_of: :locations
  has_many :offers, inverse_of: :location

  # Validations
  validates :name, length: { maximum: 100 }
  validates :street, presence: true,
                     format: /\A.+\d+.*\z/ # ensure digit for house number
  validates :addition, length: { maximum: 255 }
  validates :zip, presence: true, length: { is: 5 }
  validates :city, presence: true
  validates :area_code, format: /\A\d*\z/, length: { maximum: 6 }
  validates :local_number, format: /\A\d*\z/, length: { maximum: 32 }
  validates :email, format: Email::FORMAT, allow_blank: true
  validates :display_name, presence: true

  validates :organization_id, presence: true
  validates :federal_state_id, presence: true

  # Scopes
  scope :hq, -> { where(hq: true).limit(1) }

  # Geocoding
  geocoded_by :full_address

  # Methods

  delegate :name, to: :federal_state, prefix: true
  delegate :name, to: :organization, prefix: true, allow_nil: true

  before_validation :generate_display_name
  def generate_display_name
    self.display_name =
      if name && !name.empty?
        "#{organization_name}, #{name} (#{street} #{zip} #{city})"
      else
        "#{organization_name}, #{street} #{zip} #{city}"
      end
  end

  def address
    "#{street}, #{zip} #{city}"
  end

  private

  def full_address
    "#{address} #{federal_state_name}"
  end
end
