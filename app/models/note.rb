# Comment for internal use by admins.
# Allows adding note to any other Model. Displayed in Admin backend.
class Note < ActiveRecord::Base
  # Associations
  belongs_to :notable, polymorphic: true

  belongs_to :referencable, polymorphic: true
  belongs_to :user, inverse_of: :notes # Author

  # Enumerization
  extend Enumerize
  enumerize :topic, in: %w(todo history hidden_contact external_info other)

  # Validations
  validates :text, presence: true, length: { maximum: 800 }
  validates :topic, presence: true

  validates :notable, presence: true
  validates :user, presence: true
end
