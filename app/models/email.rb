# A unique email address
class Email < ActiveRecord::Base
  include AASM

  attr_accessor :given_security_code

  # Associations
  has_many :contact_people, inverse_of: :email
  has_many :offers, through: :contact_people, inverse_of: :emails

  # Validations
  validates :address, uniqueness: true, presence: true, format: /\A.+@.+\z/,
                      length: { minimum: 3, maximum: 64 }

  validates :security_code, presence: true, uniqueness: true, on: :update

  # State Machine
  aasm do
    state :uninformed, initial: true # E-Mail was created, owner doesn't know
    state :informed # An offer has been approved and the owner got sent info
    state :subscribed # Email recipient has subscribed to further updates
    state :unsubscribed # Email recipient was subscribed but is no longer

    event :inform do
      transitions from: :uninformed, to: :informed,
                  guard: :approved_offers?, after: :send_information
    end

    event :subscribe, guard: :security_code_confirmed? do
      transitions from: :informed, to: :subscribed,
                  on_transition: :regenerate_security_code
      transitions from: :unsubscribed, to: :subscribed,
                  on_transition: :regenerate_security_code
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

  def send_information
    OfferMailer.delay.inform self
  end
end
