require 'ffaker'

FactoryGirl.define do
  factory :category do
    name { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }

    after :build do |category|
      # Filters
      category.section_filters << (
        SectionFilter.first || FactoryGirl.create(:section_filter)
      )
    end
    trait :main do
      icon 'a-something'
    end
  end
end
