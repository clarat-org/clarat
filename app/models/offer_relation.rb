class OfferRelation < ActiveRecord::Base
  belongs_to :offer
  belongs_to :related, class_name: 'Offer'

  validates :offer, presence: true
  validates :related, presence: true
end
