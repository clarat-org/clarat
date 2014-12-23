require 'ffaker'

FactoryGirl.define do
  factory :organization do
    # required
    name { Faker::Lorem.words(rand(2..3)).join(' ').titleize }
    description { Faker::Lorem.paragraph(rand(4..6))[0..399] }
    legal_form { Organization.enumerized_attributes.attributes['legal_form'].values.sample }
    charitable { Faker::Boolean.maybe }
    completed { Faker::Boolean.maybe }

    # optional
    comment { maybe Faker::Lorem.paragraph(rand(4..6))[0..399] }
    founded { maybe((1980..Time.now.year).to_a.sample) }
    umbrella { maybe Organization.enumerized_attributes.attributes['umbrella'].values.sample }

    # associations
    ignore do
      website_count { rand(0..3) }
    end

    after :create do |orga, evaluator|
      create_list :hyperlink, evaluator.website_count, linkable: orga
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
