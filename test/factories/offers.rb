require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { Faker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { Faker::Lorem.paragraph(rand(4..6))[0..399] }
    todo { Faker::Lorem.paragraph(rand(1..3))[0..399] }
    reach { Offer.enumerized_attributes.attributes['reach'].values.sample }
    frequent_changes { Faker::Boolean.maybe }
    completed { Faker::Boolean.maybe }

    # optional fields
    keywords { maybe Faker::Lorem.words(rand(0..3)).join(', ') }
    telephone { maybe Faker.numerify('#'*rand(7..11)) }
    fax { (rand(2)==0 && telephone) ? Faker.numerify('#'*rand(7..11)) : nil }
    contact_name { maybe Faker::NameDE.name }
    email { maybe Faker::Internet.email }

    # associations
    organization
    location do
      reach == 'national' ? nil : (
        organization.locations.sample ||
        FactoryGirl.create(:location, organization: organization)
      )
    end

    ignore do
      website_count { rand(0..3) }
      tag_count { rand(1..3) }
      language_count { rand(1..2) }
      opening_count { rand(1..5) }
    end
    after :create do |offer, evaluator|
      create_list :hyperlink, evaluator.website_count, linkable: offer
      evaluator.tag_count.times do
        offer.tags << (
          rand(2)==0 ? FactoryGirl.create(:tag) : Tag.select(:id).all.sample
        )
      end
      evaluator.opening_count.times do
        offer.openings << (
          rand(2)==0 ? FactoryGirl.create(:opening) : Opening.select(:id).all.sample
        )
      end
      evaluator.language_count.times do
        offer.languages << (
          Language.select(:id).all.sample || FactoryGirl.create(:language)
        )
      end
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
