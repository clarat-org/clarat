class Offer < ActiveRecord::Base
  has_paper_trail
  # Associtations
  belongs_to :location, inverse_of: :offers
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :openings
  belongs_to :organization, inverse_of: :offers, counter_cache: true
  # Attention: former has_one :organization, through: :locations - but there can also be offers without locations
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Enumerization
  extend Enumerize
  enumerize :encounter, in: %w(fixed determinable independent)

  # Friendly ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged]

  include Approvable
  before_save :add_approved_at

  def slug_candidates
    [
      :name,
      [:name, :location_zip]
    ]
  end

  # Validations
  validates :name, length: { maximum: 80 }, presence: true,
    uniqueness: { scope: :location_id }
  validates :description, length: { maximum: 400 }, presence: true
  validates :next_steps, length: { maximum: 500 }, presence: true
  validates :encounter, presence: true
  validates :fax, format: /\A\d*\z/, length: { maximum: 32 }
  validates :telephone, format: /\A\d*\z/, length: { maximum: 32 }
  validates :second_telephone, format: /\A\d*\z/, length: { maximum: 32 }
  validates :opening_specification, length: { maximum: 400 }
  validates :legal_information, length: { maximum: 400 }
  validates :comment, length: { maximum: 800 }
  validates :organization_id, presence: true
  validates :approved, approved: true
  # Custom validations
  validate :location_fits_organization
  validates :approved, approved: true

  # Search
  include AlgoliaSearch
  algoliasearch per_environment: true,
                disable_indexing: Rails.env.test?,
                if: :approved? do
    attributesToIndex ['name', 'description']
    ranking %w(typo custom geo words proximity attribute exact) # ^custom
    customRanking ['asc(encounter_value)']
    add_attribute :_geoloc
    add_attribute :_tags
    add_attribute :organization_name
    add_attribute :location_street
    add_attribute :location_city
    add_attribute :location_zip
    add_attribute :encounter_value
    attributesForFaceting [:_tags]
  end

  # Statistics
  extend RailsAdminStatistics

  # Methods

  delegate :name, to: :organization, prefix: true
  delegate :name, :street, :addition, :city, :zip,
           to: :location, prefix: true, allow_nil: true

  # Offer's location's geo coordinates for indexing
  def _geoloc
    {
      'lat' => location.try(:latitude) || '0.0',
      'lng' => location.try(:longitude) || '0.0'
    }
  end

  # Offer's tags for indexing
  def _tags
    tags.map(&:name)
  end

  # Offer's encounter modifier for indexing
  def encounter_value
    case encounter
    when 'independent' then 0
    when 'determinable', 'fixed' then 1
    end
  end

  def creator_email
    creator = User.find(versions.first.whodunnit)
    creator.email
  rescue
    'anonymous'
  end

  def partial_dup
    self.dup.tap do |offer|
      offer.name = nil
      offer.telephone = nil
      offer.second_telephone = nil
      offer.fax = nil
      offer.contact_name = nil
      offer.email = nil
      offer.openings = []
      offer.opening_specification = nil
      offer.completed = false
      offer.approved = false
      offer.tags = self.tags
    end
  end

  def has_contact_details?
    # ToDo: Refactor!
    if contact_name.empty? && telephone.empty? && fax.empty? && email.empty? &&
      websites.empty?
      false
    else
      true
    end
  end

  def has_social_media_websites?
    websites.facebook.first || websites.twitter.first ||
    websites.youtube.first || websites.gplus.first || websites.pinterest.first
  end

  private

    # Custom Validation: Ensure selected organization is the same as the selected location's organization
    def location_fits_organization
      if location && location.organization_id != organization_id
        errors.add(:location_id, I18n.t(
          'validations.offer.location_fits_organization.location_error'))
        errors.add(:organization_id, I18n.t(
          'validations.offer.location_fits_organization.organization_error'))
      end
    end
end
