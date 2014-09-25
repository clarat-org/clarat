class Website < ActiveRecord::Base
  # associtations
  has_many :hyperlinks, as: :linkable

  # Enumerization
  extend Enumerize
  enumerize :sort, in: %w[own facebook twitter youtube gplus pinterest other]

  # Validations
  validates :sort, presence: true
  validates :url, format: %r{https?://\S+\.\S+}, uniqueness: true, presence: true
end
