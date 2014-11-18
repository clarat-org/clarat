require 'ffaker'

FactoryGirl.define do
  factory :tag do
    name { Faker::Lorem.words(rand(2..3)).join(' ').titleize }
    main { Faker::Boolean.maybe }

    # associations
    ignore do
      associated_tag_count { rand(1..3) }
    end
    after :create do |tag, evaluator|
      evaluator.associated_tag_count.times do
        tag.associated_tags << FactoryGirl.create(:tag, associated_tag_count: 0)
      end
    end
  end
end
