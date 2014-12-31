class Contact < ActiveRecord::Base
  # Attributes
  attr_accessor :reporting

  # Validations
  validates :name, presence: true, allow_blank: false
  validates :email,
            presence: true,
            allow_blank: false,
            format: /\A.+@.+\..+\z/,
            unless: ->(contact) { contact.reporting }
  validates :message, presence: true, allow_blank: false
end
