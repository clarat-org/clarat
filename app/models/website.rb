class Website < ActiveRecord::Base
  # associtations
  has_many :hyperlinks, as: :linkable

  # Enumerization
  extend Enumerize
  # TODO: Rename 'sort'
  enumerize :sort, in: %w(own facebook twitter youtube gplus pinterest other)

  # Validations
  validates :sort, presence: true
  validates :url, format: %r{\Ahttps?://\S+\.\S+\z}, uniqueness: true,
    presence: true

  # Scopes
  scope :own, -> { where(sort: 'own') }
  scope :facebook, -> { where(sort: 'facebook') }
  scope :twitter, -> { where(sort: 'twitter') }
  scope :youtube, -> { where(sort: 'youtube') }
  scope :gplus, -> { where(sort: 'gplus') }
  scope :pinterest, -> { where(sort: 'pinterest') }
  scope :other, -> { where(sort: 'other') }
end
