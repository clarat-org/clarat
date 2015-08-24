# A unique email address
class Email < ActiveRecord::Base
  include AASM

  attr_accessor :given_security_code

  # Associations
  has_many :contact_people, inverse_of: :email
  has_many :offers, through: :contact_people, inverse_of: :emails
  has_many :organizations, through: :contact_people, inverse_of: :emails

  has_many :offer_mailings, inverse_of: :email
  has_many :known_offers, source: :offer, through: :offer_mailings,
                          inverse_of: :informed_emails

  # Validations
  FORMAT = /\A.+@.+\..+\z/
  validates :address, uniqueness: true, presence: true, format: Email::FORMAT,
                      length: { minimum: 3, maximum: 64 }

  validates :security_code, presence: true, uniqueness: true, on: :update

  # State Machine
  aasm do
    state :uninformed, initial: true # E-Mail was created, owner doesn't know
    state :informed, # An offer has been approved and the owner got sent info
          after_enter: :send_information
    state :subscribed # Email recipient has subscribed to further updates
    state :unsubscribed # Email recipient was subscribed but is no longer

    event :inform, guard: :informable? do
      # Else send email if there are approved offers
      transitions from: :uninformed, to: :informed,
                  after: :regenerate_security_code
    end

    event :subscribe, guard: :security_code_confirmed? do
      transitions from: :informed, to: :subscribed,
                  after: :regenerate_security_code
      transitions from: :unsubscribed, to: :subscribed,
                  after: :regenerate_security_code
    end

    event :unsubscribe do
      transitions from: :subscribed, to: :unsubscribed
    end
  end

  # Methods

  def security_code_confirmed?
    given_security_code == security_code
  end

  def create_offer_mailings offers, mailing_type
    offers.each do |offer|
      OfferMailing.create! offer_id: offer.id, email_id: id,
                           mailing_type: mailing_type
    end
  end

  def not_yet_known_but_approved_offers
    offers.approved.all - known_offers.all
  end

  private

  def regenerate_security_code
    self.security_code = SecureRandom.uuid
  end

  # Has approved offers and at least one organization is mailings_enabled?
  def informable?
    contact_people.joins(:offers).where('offers.approved = ?', true).any? &&
      organizations.where(mailings_enabled: true).any?
  end

  def send_information
    OfferMailer.inform(self).deliver
  end
end
