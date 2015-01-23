class Contact < ActiveRecord::Base
  # Attributes
  attr_accessor :reporting

  # Validations
  validates :name, presence: true, allow_blank: false
  validates :email,
            format: /\A.+@.+\..+\z/, allow_blank: false,
            if: ->(contact) { contact.reporting.blank? }
  validates :email,
            format: /\A.+@.+\..+\z/, allow_blank: true,
            unless: ->(contact) { contact.reporting.blank? }
  validates :message, presence: true, allow_blank: false
end
