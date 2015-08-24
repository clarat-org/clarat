# One of the main models. The offers that visitors want to find.
# Has modules in offer subfolder.
class Offer < ActiveRecord::Base
  has_paper_trail

  # Modules
  include Validations, Search, Statistics

  # Concerns
  include Creator, CustomValidatable, Notable

  # Associtations
  belongs_to :location, inverse_of: :offers
  belongs_to :area, inverse_of: :offers
  has_and_belongs_to_many :categories
  has_and_belongs_to_many :filters
  has_and_belongs_to_many :language_filters,
                          association_foreign_key: 'filter_id',
                          join_table: 'filters_offers'
  has_and_belongs_to_many :age_filters,
                          association_foreign_key: 'filter_id',
                          join_table: 'filters_offers'
  has_and_belongs_to_many :openings
  has_and_belongs_to_many :keywords, inverse_of: :offers
  has_many :contact_person_offers, inverse_of: :offer
  has_many :contact_people, through: :contact_person_offers, inverse_of: :offers
  has_many :emails, through: :contact_people, inverse_of: :offers
  has_many :organization_offers, dependent: :destroy
  has_many :organizations, through: :organization_offers, inverse_of: :offers
  # Attention: former has_one :organization, through: :locations
  # but there can also be offers without locations
  has_many :hyperlinks, as: :linkable, dependent: :destroy
  has_many :websites, through: :hyperlinks
  has_many :offer_mailings, inverse_of: :offer
  has_many :informed_emails, source: :email, through: :offer_mailings,
                             inverse_of: :known_offers

  # Enumerization
  extend Enumerize
  enumerize :encounter, in: %w(personal hotline email chat forum online-course)
  enumerize :unapproved_reason, in: %w(N/A not_approved expired paused
                                       internal_review external_feedback)
  enumerize :target_gender, in: %w(whatever boys_only girls_only)
  enumerize :target_audience, in: %w(children parents family acquintances)

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
  scope :approved, -> { where(aasm_state: 'approved') }
  scope :by_mailings_enabled_organization, lambda {
    joins(:organizations).where('organizations.mailings_enabled = ?', true)
  }

  # Methods

  delegate :name, :street, :addition, :city, :zip, :address,
           to: :location, prefix: true, allow_nil: true

  delegate :minlat, :maxlat, :minlong, :maxlong,
           to: :area, prefix: true, allow_nil: true

  def partial_dup
    self.dup.tap do |offer|
      offer.location = nil
      offer.organizations = self.organizations
      offer.openings = self.openings
      offer.categories = self.categories
      offer.language_filters = self.language_filters
      offer.websites = self.websites
      offer.contact_people = []
      offer.completed = false
      offer.approved = false
    end
  end

  include AASM
  aasm do
    ## States

    # Normal Workflow
    state :initialized, initial: true
    state :completed
    state :approved, after_enter: :after_approve

    # Special states object might enter after it was approved
    state :paused # I.e. Seasonal offer is in off-season
    state :expired # Happens automatically after a pre-set amount of time
    state :internal_feedback # There was an issue (internal)
    state :external_feedback # There was an issue (external)


    ## Transitions

    event :complete do
      transitions from: :initialized, to: :completed
    end

    event :approve, before: :set_approved_information do
      transitions from: :completed, to: :approved, guard: :different_actor?
      transitions from: :paused, to: :approved
      transitions from: :expired, to: :approved
      transitions from: :internal_feedback, to: :approved
      transitions from: :external_feedback, to: :approved
    end

    event :pause do
      transitions from: :approved, to: :paused
      transitions from: :expired, to: :paused
      transitions from: :internal_feedback, to: :paused
      transitions from: :external_feedback, to: :paused
    end

    event :expire do
      transitions from: :approved, to: :expired
      transitions from: :paused, to: :expired
      transitions from: :internal_feedback, to: :expired
      transitions from: :external_feedback, to: :expired
    end

    event :deactivate_internal do
      transitions from: :approved, to: :internal_feedback
      transitions from: :paused, to: :internal_feedback
      transitions from: :expired, to: :internal_feedback
      transitions from: :external_feedback, to: :internal_feedback
    end

    event :deactivate_external do
      transitions from: :approved, to: :external_feedback
      transitions from: :paused, to: :external_feedback
      transitions from: :expired, to: :external_feedback
      transitions from: :internal_feedback, to: :external_feedback
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

  def set_approved_information
    self.approved_at = Time.zone.now
    self.approved_by = ::PaperTrail.whodunnit
  end

  def different_actor?
    created_by && approved_by && created_by != approved_by
  end
end
