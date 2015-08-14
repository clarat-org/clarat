module Notable
  extend ActiveSupport::Concern

  included do
    has_many :notes, as: :notable, inverse_of: :notable
    has_many :referencing_notes, class_name: 'Note', as: :referencable,
                                 inverse_of: :referencable

    accepts_nested_attributes_for :notes
  end
end
