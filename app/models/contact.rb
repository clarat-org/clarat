class Contact < ActiveRecord::Base
  # Attributes
  attr_accessor :reporting

  # Validations
  validates :name, presence: true, allow_blank: false
  validates :email,
            format: /\A.+@.+\..+\z/,
            if: ->(contact) { contact.reporting.blank? }
  validates :message, presence: true, allow_blank: false
end
