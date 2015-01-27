require 'ffaker'

FactoryGirl.define do
  factory :tag do
    name { Faker::Lorem.words(rand(2..3)).join(' ').titleize }
    main { Faker::Boolean.maybe }

    # associations
    ignore do
      dependent_tag_count { rand(0..3) }
    end
    after :create do |tag, evaluator|
      evaluator.dependent_tag_count.times do
        tag.dependent_tags << FactoryGirl.create(:tag, dependent_tag_count: 0)
      end
    end

    trait :main do
      main true
      dependent_tag_count 0 # ?
    end
  end
end
