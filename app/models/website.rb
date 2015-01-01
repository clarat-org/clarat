class Website < ActiveRecord::Base
  # associtations
  has_many :hyperlinks, as: :linkable

  # Enumerization
  extend Enumerize
  enumerize :host, in: %w(own facebook twitter youtube gplus pinterest other)

  # Validations
  validates :host, presence: true
  validates :url, format: %r{\Ahttps?://\S+\.\S+\z}, uniqueness: true,
    presence: true

  # Scopes
  scope :own, -> { where(host: 'own') }
  scope :facebook, -> { where(host: 'facebook') }
  scope :twitter, -> { where(host: 'twitter') }
  scope :youtube, -> { where(host: 'youtube') }
  scope :gplus, -> { where(host: 'gplus') }
  scope :pinterest, -> { where(host: 'pinterest') }
  scope :other, -> { where(host: 'other') }
end
