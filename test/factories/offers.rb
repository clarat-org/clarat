require 'ffaker'

FactoryGirl.define do
  factory :offer do
    # required fields
    name { FFaker::Lorem.words(rand(3..5)).join(' ').titleize }
    description { FFaker::Lorem.paragraph(rand(4..6))[0..399] }
    next_steps { FFaker::Lorem.paragraph(rand(1..3))[0..399] }
    completed false
    approved false
    approved_at nil

    # optional fields
    comment { maybe FFaker::Lorem.paragraph(rand(4..6))[0..799] }

    # associations

    encounter_filters do
      encounters = %w(personal hotline online)
      selected = encounters.sample(rand(1..3))
      selected.map { |s| EncounterFilter.find_by_identifier(s) }
    end

    transient do
      organization_count 1
      contact_person_count 1
      website_count { rand(0..3) }
      category_count { rand(1..3) }
      category nil # used to get a specific category, instead of category_count
      language_count { rand(1..2) }
      opening_count { rand(1..5) }
      local_offer { maybe true }
    end

    after :create do |offer, evaluator|
      # organization
      evaluator.organization_count.times do
        FactoryGirl.create :organization_offer, offer: offer
      end

      # location
      organization = offer.organizations.first
      if organization && (offer.personal? || evaluator.local_offer)
        location = organization.locations.sample ||
                   FactoryGirl.create(:location, organization: organization)
        offer.update_column :location_id, location.id
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
        offer.categories << FactoryGirl.create(:category,
                                               name: evaluator.category)
      else
        evaluator.category_count.times do
          offer.categories << (
            Category.select(:id).all.sample
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
        Offer.where(id: offer.id).update_all completed: true, approved: true,
                                             approved_at: Time.now
      end
      approved_by { FactoryGirl.create(:researcher).id }
    end

    # TODO: Introduce encounter_filter instead
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
