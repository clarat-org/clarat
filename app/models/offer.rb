class Offer < ActiveRecord::Base
  has_paper_trail

  # Modules
  include Validations, Search, Statistics

  # Concerns
  include Creator, Approvable

  # Associtations
  belongs_to :location, inverse_of: :offers
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :openings
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

  # Methods

  delegate :name, :street, :addition, :city, :zip, :address,
           to: :location, prefix: true, allow_nil: true

  def partial_dup
    self.dup.tap do |offer|
      offer.name = nil
      offer.telephone = nil
      offer.second_telephone = nil
      offer.fax = nil
      offer.contact_name = nil
      offer.email = nil
      offer.openings = self.openings
      offer.completed = false
      offer.approved = false
      offer.categories = self.categories
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
