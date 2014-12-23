require 'ffaker'

FactoryGirl.define do
  factory :location do
    # required
    street 'Foobar 1'
    zip '12345'
    city 'Berlin'
    hq { rand(9) == 0 }

    latitude { rand 52.4..52.6 } # somewhere within approximate bounds of Berlin
    longitude { rand 13.25..13.6 }

    # optional
    name { maybe Faker::NameDE.name }
    addition do
      maybe [
        "#{rand(1..3)}. Hinterhof",
        "#{rand(1..10)}. Stock",
        "Raum #{rand(1..20)}"
      ].sample
    end
    telephone { maybe Faker.numerify('#' * rand(7..11)) }
    second_telephone { (rand(2) == 0 && telephone) ? Faker.numerify('#' * rand(7..11)) : nil }
    fax { (rand(2) == 0 && telephone) ? Faker.numerify('#' * rand(7..11)) : nil }
    email { maybe Faker::Internet.email }

    # associations
    organization
    federal_state { FederalState.select(:id).all.sample || FederalState.create(name: 'Berlin') }

    ignore do
      website_count { rand(0..3) }
    end
    after :create do |location, evaluator|
      create_list :hyperlink, evaluator.website_count, linkable: location
    end

    trait :fake_address do
      street { Faker::AddressDE.street_address }
      zip { (10_000..14_100).to_a.sample }
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
