module Notable
  extend ActiveSupport::Concern

  included do
    has_many :notes, as: :notable
    has_many :referencing_notes, as: :referencable
  end
end
