class Offer < ActiveRecord::Base
  has_paper_trail

  # Modules
  include Validations, Search, Statistics

  # Concerns
  include Creator, Approvable, CustomValidatable

  # Associtations
  belongs_to :location, inverse_of: :offers
  belongs_to :area, inverse_of: :offers
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :filters
  has_and_belongs_to_many :language_filters,
                          association_foreign_key: 'filter_id',
                          join_table: 'filters_offers'
  has_and_belongs_to_many :audience_filters,
                          association_foreign_key: 'filter_id',
                          join_table: 'filters_offers'
  has_and_belongs_to_many :age_filters,
                          association_foreign_key: 'filter_id',
                          join_table: 'filters_offers'
  has_and_belongs_to_many :encounter_filters,
                          association_foreign_key: 'filter_id',
                          join_table: 'filters_offers'
  has_and_belongs_to_many :openings
  has_and_belongs_to_many :keywords, inverse_of: :offers
  has_many :contact_person_offers, inverse_of: :offer
  has_many :contact_people, through: :contact_person_offers
  has_many :organization_offers
  has_many :organizations, through: :organization_offers
  # Attention: former has_one :organization, through: :locations
  # but there can also be offers without locations
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Enumerization
  extend Enumerize
  enumerize :encounter, in: %w(fixed determinable independent)

  # Friendly ID
  extend FriendlyId
  friendly_id :slug_candidates, use: [:slugged]

  def slug_candidates
    [
      :name,
      [:name, :location_zip]
    ]
  end

  # Scopes
  scope :approved, -> { where(approved: true) }

  # Methods

  delegate :name, :street, :addition, :city, :zip, :address,
           to: :location, prefix: true, allow_nil: true

  delegate :minlat, :maxlat, :minlong, :maxlong,
           to: :area, prefix: true, allow_nil: true

  def partial_dup
    self.dup.tap do |offer|
      offer.name = nil
      offer.openings = self.openings
      offer.completed = false
      offer.approved = false
      offer.categories = self.categories
      offer.contact_people = []
    end
  end

  def contact_details?
    websites.any? || contact_people.any?
  end

  def social_media_websites?
    websites.where(host: [:facebook, :twitter, :youtube, :gplus, :pinterest])
      .count > 0
  end

  def opening_details?
    !openings.blank? || !opening_specification.blank?
  end

  def organization_display_name
    if organizations.count > 1
      I18n.t 'offers.index.cooperation'
    else
      organizations.first.name
    end
  end

  def gmaps_info
    {
      title: name,
      address: location_address,
      organization_display_name: organization_display_name
    }
  end
end
