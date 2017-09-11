require 'ffaker'

FactoryGirl.define do
  factory :category do
    name_de { FFaker::Lorem.words(rand(2..3)).join(' ').titleize }
    name_en { name_de + ' (en)' }

    transient do
      sections do
        [Section.first || FactoryGirl.create(:section)]
      end
    end

    after :build do |category, evaluator|
      # Filters
      evaluator.sections.each do |section|
        category.sections << section
      end
    end

    trait :main do
      icon 'a-something'
    end
  end
end
