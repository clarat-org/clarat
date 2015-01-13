require 'ffaker'

FactoryGirl.define do
  factory :tag do
    name { Faker::Lorem.words(rand(2..3)).join(' ').titleize }
    main { Faker::Boolean.maybe }

    # associations
    ignore do
      dependent_tag_count { rand(1..3) }
    end
    after :create do |tag, evaluator|
      evaluator.dependent_tag_count.times do
        tag.dependent_tags << FactoryGirl.create(:tag, dependent_tag_count: 0)
      end
    end
  end
end
