class Organization < ActiveRecord::Base
  has_paper_trail

  # Associtations
  has_many :offers, through: :organizations
  has_many :locations
  has_many :offers
  has_many :hyperlinks, as: :linkable
  has_many :websites, through: :hyperlinks

  # Enumerization
  extend Enumerize
  enumerize :legal_form, in: %w(ev ggmbh gag foundation gug kdor ador kirche
                                gmbh ag ug kfm gbr ohg kg eg sonstige
                                state_entity)
  enumerize :umbrella, in: %w(caritas diakonie awo dpw drk zwst)

  # Friendly ID
  extend FriendlyId
  friendly_id :name, use: [:slugged]

  include Approvable
  before_save :add_approved_at

  # Validations
  validates :name, length: { maximum: 100 }, presence: true, uniqueness: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :legal_form, presence: true
  validates :founded, length: { is: 4 }, allow_blank: true
  validates :keywords, length: { maximum: 150 }
  # Custom Validations
  validates :approved, approved: true

  def creator_email
    creator = User.find(versions.first.whodunnit)
    creator.email
  end

end
