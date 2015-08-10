# A submitted contact form on our platform to ask questions or give feedback.
class Contact < ActiveRecord::Base
  # Attributes #

  # reporting: was focussed on a specific offer or orga; visitor found an issue
  # with it
  attr_accessor :reporting

  # Validations

  validates :name, presence: true, allow_blank: false
  validates :email,
            format: Email::FORMAT, allow_blank: false, unless: :reporting?
  validates :email,
            format: Email::FORMAT, allow_blank: true, if: :reporting?
  validates :message, presence: true, allow_blank: false

  def reporting?
    !reporting.blank? # could be true, nil, false, or empty string
  end
end
