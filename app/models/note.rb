# Comment for internal use by admins.
# Allows adding note to any other Model. Displayed in Admin backend.
class Note < ActiveRecord::Base
  # Concerns
  include NoteReferencable # A note can be the target of references

  # Associations
  belongs_to :notable, polymorphic: true # , inverse_of: :notes

  belongs_to :referencable, polymorphic: true, inverse_of: :referencing_notes
  belongs_to :user, inverse_of: :authored_notes # Author

  # Scopes
  scope :not_referencing_note, lambda {
    where(
      'notes.referencable_type IS NULL OR notes.referencable_type != ?', 'Note'
    )
  }

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
