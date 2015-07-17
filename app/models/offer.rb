# One of the main models. The offers that visitors want to find.
# Has modules in offer subfolder.
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
  has_and_belongs_to_many :openings
  has_and_belongs_to_many :keywords, inverse_of: :offers
  has_many :contact_person_offers, inverse_of: :offer
  has_many :contact_people, through: :contact_person_offers, inverse_of: :offers
  has_many :organization_offers
  has_many :organizations, through: :organization_offers
  # Attention: former has_one :organization, through: :locations
  # but there can also be offers without locations
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Enumerization
  extend Enumerize
  enumerize :encounter, in: %w(personal hotline email chat forum online-course)
  enumerize :unapproved_reason, in: %w(N/A not_approved expired wip paused)

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

  include AASM
  aasm do
    ## States

    # Normal Workflow
    state :initialized
    state :ready_for_approval
    state :approved

    # Temporary Workflow
    state :in_renewal
    state :renewed

    # Special states object might enter after it was approved
    state :expired # Happens automatically after a pre-set amount of time
    state :deactivated # There was an issue
    state :paused # I.e. Seasonal offer is in off-season


    ## Transitions

    event :advance do
      transitions from: :initialized, to: :ready_for_approval
      transitions from: :ready_for_approval, to: :approved

      # Temporary
      transitions from: :in_renewal, to: :renewed
      transitions from: :renewed, to: :approved
    end

    event :expire do
      transitions to: :expired
    end

    event :deactivate do
      transitions to: :deactivated
    end

    event :pause do
      transitions to: :paused
    end
  end

  # handled in observer before save
  def generate_html
    self.description_html = MarkdownRenderer.render description
    self.description_html = Definition.infuse description_html
    self.next_steps_html = MarkdownRenderer.render next_steps
    if opening_specification
      self.opening_specification_html =
        MarkdownRenderer.render opening_specification
    end
  end

  # Get an array of websites, ordered as follows: (1) own non-pdf (2) own pdf
  # (3+) remaining HOSTS in order, except "other"
  def structured_websites
    # TODO: Refactor!
    sites = [
      websites.own.non_pdf.first,
      websites.own.pdf.first
    ]
    Website::HOSTS[1..-2].each do |host| # no "other"
      sites << websites.send(host).first
    end
    sites.compact
  end

  def opening_details?
    !openings.blank? || !opening_specification.blank?
  end

  def organization_display_name
    if organizations.count > 1
      I18n.t 'offer.organization_display_name.cooperation'
    elsif organizations.any?
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
