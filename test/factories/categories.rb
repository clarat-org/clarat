require 'ffaker'

FactoryGirl.define do
  factory :category do
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }

    trait :main do
      icon 'a-something'
    end
  end
end
