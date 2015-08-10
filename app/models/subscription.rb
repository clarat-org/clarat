# Newsletter Subscription
class Subscription < ActiveRecord::Base
  # Validations
  validates :email, format: Email::FORMAT
end
