# A submitted contact form on our platform to ask questions or give feedback.
class Contact < ActiveRecord::Base
  # Attributes #

  # reporting: was focussed on a specific offer or orga; visitor found an issue
  # with it
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
