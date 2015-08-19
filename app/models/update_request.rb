# Created when a user requests email updates about the site's covered area.
class UpdateRequest < ActiveRecord::Base
  # Validations
  validates :search_location, presence: true
  validates :email, format: Email::FORMAT
end
