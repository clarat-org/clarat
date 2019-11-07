# frozen_string_literal: true

require 'ffaker'

FactoryBot.define do
  factory :location do
    # required
    sequence(:street) { |n| "Foobar #{n}" }
    label { "… #{name} | #{street} …" }
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

    # associations
    federal_state do
      FederalState.all.to_a.sample || FederalState.create!(
        name: 'Berlin'
      )
    end
    city { City.all.to_a.sample || City.create!(name: 'Berlin') }
    organization { Organization.last || FactoryBot.create(:organization) }

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
