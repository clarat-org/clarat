require 'ffaker'

FactoryGirl.define do
  factory :search_location do
    query { FFaker::AddressDE.city }
    latitude { rand 0.0..90.0 }
    longitude { rand 0.0..90.0 }
    geoloc { "#{latitude},#{longitude}" }
  end
end
