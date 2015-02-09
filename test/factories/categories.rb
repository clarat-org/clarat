require 'ffaker'

FactoryGirl.define do
  factory :category do
    name { Faker::Lorem.words(rand(2..3)).join(' ').titleize }

    # associations
    ignore do
      dependent_category_count { rand(0..3) }
    end
    after :create do |cat, evaluator|
      evaluator.dependent_category_count.times do
        cat.dependent_categories <<
          FactoryGirl.create(:category, dependent_category_count: 0)
      end
    end

    trait :main do
      icon 'a-something'
      dependent_category_count 0 # ?
    end
  end
end
