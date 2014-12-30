class Contact < ActiveRecord::Base
  # Validations
  validates :name, presence: true, allow_blank: false
  validates :email, presence: true, allow_blank: false, format: /\A.+@.+\..+\z/
  validates :message, presence: true, allow_blank: false
end
