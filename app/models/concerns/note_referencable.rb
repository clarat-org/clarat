module NoteReferencable
  extend ActiveSupport::Concern

  included do
    has_many :referencing_notes, class_name: 'Note', as: :referencable,
                                 inverse_of: :referencable
  end
end
