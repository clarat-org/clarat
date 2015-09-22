#
# y /|\
#    |     @   <- an instance of this model
#    |
#    +------->
#           x (date)
# #topic => the topic / category that this point belongs to
# #user => Reference to the one this point is about
class Statistic < ActiveRecord::Base
  # Associations
  belongs_to :user

  # Validations
  validates :topic, presence: true, uniqueness: { scope: [:x, :user_id] }
  validates :x, presence: true, uniqueness: { scope: [:topic, :user_id] }
  validates :y, presence: true, numericality: true

  # Enumerization
  extend Enumerize
  TOPICS = %w(
    offer_created offer_approved organization_created organization_approved
  )
  enumerize :topic, in: TOPICS

  # Scopes
  default_scope { order('x ASC') }
  TOPICS.each do |topic|
    scope topic.to_sym, -> { where(topic: topic) }
  end
end
