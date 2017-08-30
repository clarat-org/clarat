# frozen_string_literal: true
require 'ffaker'

FactoryGirl.define do
  factory :federal_state do
    name 'Berlin'

    # after :create do |fs, evaluator|
    #   # Locations
    #   create_list(:location, 1)
    # end
  end
end
