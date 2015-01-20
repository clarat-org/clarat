class Offer < ActiveRecord::Base
  has_paper_trail

  # Modules
  include Validations, Search, Tagging, Statistics

  # Concerns
  include Creator, Approvable

  # Associtations
  belongs_to :location, inverse_of: :offers
  has_and_belongs_to_many :tags, after_add: :add_dependent_tags
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

  def slug_candidates
    [
      :name,
      [:name, :location_zip]
    ]
  end

  # Scopes
  scope :approved, -> { where(approved: true, completed: true) }

  # Methods

  delegate :name, to: :organization, prefix: true
  delegate :name, :street, :addition, :city, :zip, :address,
           to: :location, prefix: true, allow_nil: true

  # Offer's encounter modifier for indexing
  def encounter_value
    case encounter
    when 'independent' then 0
    when 'determinable', 'fixed' then 1
    end
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

  def contact_details?
    !contact_name.blank? || !telephone.blank? || !fax.blank? ||
      !email.blank? || !websites.blank?
  end

  def social_media_websites?
    websites.where(host: [:facebook, :twitter, :youtube, :gplus, :pinterest])
      .count > 0
  end

  def opening_details?
    !openings.blank? || !opening_specification.blank?
  end
end
