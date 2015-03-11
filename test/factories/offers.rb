require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { Faker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { Faker::Lorem.paragraph(rand(4..6))[0..399] }
    next_steps { Faker::Lorem.paragraph(rand(1..3))[0..399] }
    encounter do
      Offer.enumerized_attributes.attributes['encounter'].values.sample
    end
    completed false
    approved false
    approved_at nil

    # optional fields
    comment { maybe Faker::Lorem.paragraph(rand(4..6))[0..799] }
    fax { maybe Faker.numerify('#' * rand(7..11)) }

    # associations

    transient do
      organization_count 1
      contact_person_count 1
      website_count { rand(0..3) }
      category_count { rand(1..3) }
      category nil # used to get a specific category, instead of category_count
      language_count { rand(1..2) }
      opening_count { rand(1..5) }
    end

    after :create do |offer, evaluator|
      # organization
      evaluator.organization_count.times do
        FactoryGirl.create :organization_offer, offer: offer
      end

      # location
      organization = offer.organizations.first
      if organization
        location = offer.encounter == 'independent' ? nil : (
          organization.locations.sample ||
          FactoryGirl.create(:location, organization: organization)
        )
        offer.update_column :location_id, location.id if location
      end

      # Contact People
      evaluator.organization_count.times do
        offer.contact_people << FactoryGirl.create(
          :contact_person, organization: organization
        )
      end

      # ...
      create_list :hyperlink, evaluator.website_count, linkable: offer
      if evaluator.category
        offer.categories << FactoryGirl.create(:category, name: evaluator.category)
      else
        evaluator.category_count.times do
          offer.categories << (
            if Category.count != 0 && rand(2) == 0
              Category.select(:id).all.sample
            else
              FactoryGirl.create(:category)
            end
          )
        end
      end
      evaluator.opening_count.times do
        offer.openings << (
          if Opening.count != 0 && rand(2) == 0
            Opening.select(:id).all.sample
          else
            FactoryGirl.create(:opening)
          end
        )
      end
      evaluator.language_count.times do
        offer.language_filters << (
          LanguageFilter.select(:id).all.sample ||
            FactoryGirl.create(:language_filter)
        )
      end
    end

    trait :approved do
      after :create do |offer, _evaluator|
        Offer.where(id: offer.id).update_all completed: true, approved: true, approved_at: Time.now
      end
      approved_by { FactoryGirl.create(:researcher).id }
    end

    trait :with_location do
      encounter 'fixed'
    end

    trait :with_creator do
      created_by { FactoryGirl.create(:researcher).id }
    end
  end
end

def maybe result
  rand(2) == 0 ? nil : result
end
