# frozen_string_literal: true
require 'ffaker'

FactoryGirl.define do
  factory :location do
    # required
    sequence(:street) { |n| "Foobar #{n}" }
    sequence(:display_name) { |n| "Foobar #{n}" }
    sequence(:zip) { |n| n.to_s.rjust(5, '0') }
    hq { rand(9).zero? }

    latitude { rand 52.4..52.6 } # somewhere within approximate bounds of Berlin
    longitude { rand 13.25..13.6 }

    # optional
    sequence(:name) { |n| maybe(FFaker::NameDE.name + n.to_s) }
    addition do
      maybe [
        "#{rand(1..3)}. Hinterhof",
        "#{rand(1..10)}. Stock",
        "Raum #{rand(1..20)}"
      ].sample
    end
    display_name 'Berlin'

    # associations
    organization
    federal_state
    city
    #association :federal_state, factory: :federal_state
    #association :city, factory: :city

    transient do
      offer_count 1
    end

    after :build do |location, evaluator|
      # Locations
      #create_list(:offer, evaluator.offer_count, location_id: location.id)

      # if evaluator.location_count.positive?
      #   orga.locations << FactoryGirl.create(:location, :hq, organization: orga)
      # end
      # if evaluator.location_count > 1
      #   create_list :location, (evaluator.location_count - 1),
      #               organization: orga, hq: false
      # end
    end

    trait :fake_address do
      street { FFaker::AddressDE.street_address }
      zip { (10_000..14_100).to_a.sample.to_s }
    end

    trait :hq do
      hq true
    end
  end
end

def maybe result
  rand(2).zero? ? nil : result
end
