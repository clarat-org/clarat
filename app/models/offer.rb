class Offer < ActiveRecord::Base
  has_paper_trail

  # associtations
  belongs_to :location, inverse_of: :offers
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :languages
  has_and_belongs_to_many :openings
  has_one :organization, through: :location, inverse_of: :offers
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Enumerization
  extend Enumerize
  enumerize :reach, in: %w[local variable national]

  # Validations
  validates :name, length: { maximum: 80 }, presence: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :todo, length: { maximum: 400 }, presence: true
  validates :reach, presence: true
end
