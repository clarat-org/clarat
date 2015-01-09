class Subscription < ActiveRecord::Base
  # Validations
  validates :email, format: /\A.+@.+\..+\z/
end
