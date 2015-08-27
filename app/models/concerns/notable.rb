module Notable
  extend ActiveSupport::Concern

  included do
    has_many :notes, as: :notable, inverse_of: :notable
    accepts_nested_attributes_for :notes
  end
end
