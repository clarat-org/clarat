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

  # Validations
  validates :name, length: { maximum: 80 }, presence: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :todo, length: { maximum: 400 }, presence: true
  validates :reach, presence: true
  validates :fax, format: /\A\d*\z/, length: { maximum: 32 }
  validates :telephone, format: /\A\d*\z/, length: { maximum: 32 }

  validates :organization_id, presence: true
  validate :location_fits_organization # custom validation

  # Search
  include AlgoliaSearch
  algoliasearch per_environment: true do
    attributesToIndex ['name', 'description']
  end

  # Methods

  private
    # Custom Validation: Ensure selected organization is the same as the selected location's organization
    def location_fits_organization
      if self.location && self.location.organization_id != self.organization_id
        errors.add(:location_id, I18n.t("validations.offer.location_fits_organization.location_error"))
        errors.add(:organization_id, I18n.t("validations.offer.location_fits_organization.organization_error"))
      end
    end
end
