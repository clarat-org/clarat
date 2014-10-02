class Offer < ActiveRecord::Base
  has_paper_trail

  # Associtations
  belongs_to :location, inverse_of: :offers
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :openings
  belongs_to :organization, inverse_of: :offers
  # Attention: former has_one :organization, through: :locations - but there can also be offers without locations
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Enumerization
  extend Enumerize
  enumerize :reach, in: %w[local variable national]

  # Friendly ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged]

  def slug_candidates
    [
      :name,
      [:name, :location_zip]
    ]
  end

  # Validations
  validates :name, length: { maximum: 80 }, presence: true, uniqueness: { scope: :location_id }
  validates :description, length: { maximum: 400 }, presence: true
  validates :next_steps, length: { maximum: 400 }, presence: true
  validates :reach, presence: true
  validates :fax, format: /\A\d*\z/, length: { maximum: 32 }
  validates :telephone, format: /\A\d*\z/, length: { maximum: 32 }
  validates :opening_specification, length: { maximum: 150 }
  validates :keywords, length: { maximum: 150 }

  validates :organization_id, presence: true
  validate :location_fits_organization # custom validation

  # Search
  include AlgoliaSearch
  algoliasearch per_environment: true, disable_indexing: Rails.env.test? do
    attributesToIndex ['name', 'description', 'keywords']
    add_attribute :_geoloc
    add_attribute :organization_name
  end

  # Methods

  delegate :name, to: :organization, prefix: true
  #cant delegate to location since it's optional
  def location_zip; location.zip if location; end

  # Offer's location's geo coordinates for indexing
  def _geoloc
    {
      'lat' => location.try(:latitude) || '0.0',
      'lng' => location.try(:longitude) || '0.0'
    }
  end

  private

    # Custom Validation: Ensure selected organization is the same as the selected location's organization
    def location_fits_organization
      if location && location.organization_id != organization_id
        errors.add(:location_id, I18n.t("validations.offer.location_fits_organization.location_error"))
        errors.add(:organization_id, I18n.t("validations.offer.location_fits_organization.organization_error"))
      end
    end
end
