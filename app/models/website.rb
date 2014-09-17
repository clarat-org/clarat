class Website < ActiveRecord::Base
  # associtations
  belongs_to :linkable, polymorphic: true, inverse_of: :websites

  # Enumerization
  extend Enumerize
  enumerize :sort, in: %w[own facebook twitter youtube gplus pinterest other]

  # Validations
  validates :sort, presence: true
  validates :url, format: /https?:\/\/\S+\.\S+/, uniqueness: true, presence: true
end
