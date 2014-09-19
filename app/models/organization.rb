class Organization < ActiveRecord::Base
  has_paper_trail

  # Associtations
  has_many :offers, through: :organizations
  has_many :locations
  has_many :offers, through: :locations
  has_many :websites, as: :linkable, inverse_of: :linkable

  # Enumerization
  extend Enumerize
  enumerize :legal_form, in: %w[ev ggmbh gag foundation gug kdor gmbh ag ug]
  enumerize :classification, in: ['Caritas', 'Diakonie', 'Arbeiterwohlfahrt',
                                  'Deutscher Paritätischer Wohlfahrtsverband',
                                  'Deutsches Rotes Kreuz',
                                  'Zentralwohlfahrtsstelle der Juden in
                                   Deutschland']

  # Validations
  validates :name, length: { maximum: 100 }, presence: true
  validates :description, length: { maximum: 400 }, presence: true
  validates :legal_form, presence: true
  validates :founded, length: { is: 4 }, allow_blank: true
end
