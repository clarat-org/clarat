# Polymorphic join model between organizations/offers and websites.
class Hyperlink < ActiveRecord::Base
  # associtations
  belongs_to :linkable, polymorphic: true, inverse_of: :websites
  belongs_to :website
end
