# frozen_string_literal: true
# Monkeypatch clarat_base Offer
require ClaratBase::Engine.root.join('app', 'models', 'location')

class Location < ApplicationRecord
	  # Associations
  belongs_to :organization, inverse_of: :locations, counter_cache: true
  belongs_to :federal_state, inverse_of: :locations
  belongs_to :city, inverse_of: :locations
  has_many :offers, inverse_of: :location

  # Validations

  # Scopes
  scope :hq, -> { where(hq: true).limit(1) }

  # Geocoding
  geocoded_by :full_address

  # Methods

  delegate :name, to: :federal_state, prefix: true
  delegate :name, to: :city, prefix: true, allow_nil: true
  delegate :name, to: :organization, prefix: true, allow_nil: true
end
