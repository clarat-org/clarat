# Comment for internal use by admins.
# Allows adding note to any other Model. Displayed in Admin backend.
class Note < ActiveRecord::Base
  # Concerns
  include Notable # A note can be the target of references

  # Associations
  belongs_to :notable, polymorphic: true # , inverse_of: :notes

  belongs_to :referencable, polymorphic: true, inverse_of: :referencing_notes
  belongs_to :user, inverse_of: :authored_notes # Author

  # Enumerization
  extend Enumerize
  enumerize :topic, in: %w(todo history hidden_contact external_info other)

  # Validations
  validates :text, presence: true, length: { maximum: 800 }
  validates :topic, presence: true

  validates :notable, presence: true
  validates :user, presence: true

  # Methods

  delegate :name, to: :user, prefix: true
end
