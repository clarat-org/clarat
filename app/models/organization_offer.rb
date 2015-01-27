# Connector model
class OrganizationOffer < ActiveRecord::Base
  belongs_to :offer
  belongs_to :organization, counter_cache: :offers_count
end
