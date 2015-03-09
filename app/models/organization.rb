class Organization < ActiveRecord::Base
  has_paper_trail

  # Concerns
  include Creator, Approvable

  # Associtations
  has_many :locations
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks
  has_many :organization_offers
  has_many :contact_people
  has_many :offers, through: :organization_offers
  has_many :child_connections, class_name: 'OrganizationConnection',
                               foreign_key: 'parent_id'
  has_many :children, through: :child_connections
  has_many :parent_connections, class_name: 'OrganizationConnection',
                                foreign_key: 'child_id'
  has_many :parents, through: :parent_connections

  # Enumerization
  extend Enumerize
  enumerize :legal_form, in: %w(ev ggmbh gag foundation gug kdor ador kirche
                                gmbh ag ug kfm gbr ohg kg eg sonstige
                                state_entity)
  enumerize :umbrella, in: %w(caritas diakonie awo dpw drk asb zwst)

  # Sanitization
  extend Sanitization
  auto_sanitize :name # TODO: add to this list

  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: [:slugged]

  # Validations
  validates :name, length: { maximum: 100 }, presence: true, uniqueness: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :legal_form, presence: true
  validates :founded, length: { is: 4 }, allow_blank: true
  validates :comment, length: { maximum: 800 }
  validates :slug, uniqueness: true

  # Custom Validations
  validates :approved, approved: true

  def before_approve
    true
  end

  # Statistics
  extend RailsAdminStatistics

  # Methods

  # finds the main (HQ) location of this organization
  def location
    @location ||= locations.hq.first
  end

  def partial_dup
    self.dup.tap do |orga|
      orga.name = nil
      orga.founded = nil
      orga.completed = false
      orga.approved = false
    end
  end

  def gmaps_info
    {
      title: name,
      address: location.address
    }
  end
end
