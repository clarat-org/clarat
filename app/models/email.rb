# A unique email address
class Email < ActiveRecord::Base
  include AASM

  attr_accessor :given_security_code

  # Associations
  has_many :contact_people, inverse_of: :email
  has_many :offers, through: :contact_people, inverse_of: :emails
  has_many :organizations, through: :contact_people, inverse_of: :emails

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
    state :blocked # Email belongs to blocked organization

    event :inform do
      # First check if email needs to be blocked
      transitions from: :uninformed, to: :blocked, guard: :should_be_blocked?
      # Else send email if there are approved offers
      transitions from: :uninformed, to: :informed,
                  guard: :approved_offers?, after: :regenerate_security_code
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

  def update_log new_text
    update_column :log, "#{log}\n#{Time.zone.now}:\n#{new_text}"
  end

  private

  def regenerate_security_code
    self.security_code = SecureRandom.uuid
  end

  def approved_offers?
    contact_people.joins(:offers).where('offers.approved = ?', true).count > 0
  end

  def should_be_blocked?
    organizations.where(inform_email_blocked: true).any? ||
      contact_people.where(spoc: true).any?
  end

  def send_information
    OfferMailer.inform(self).deliver
  end
end
